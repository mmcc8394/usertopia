#
# If it's a blog post, save it without the '/blog' prefix.
# We'll add that later by referencing url_relative.
#

class Post < ApplicationRecord
  before_validation :remove_leading_slash

  has_rich_text :content
  belongs_to :publisher, class_name: 'User', foreign_key: :published_by

  validates :title, :url, :species, :meta_description, :content, presence: true
  validates :published_by, numericality: { only_integer: true }
  validates :url, uniqueness: true
  validates :species, inclusion: { in: %w(web_page blog_post) }

  scope :live_blog_posts, -> { where("published_on <= ? and species = 'blog_post'", DateTime.now).order('published_on desc') }

  def relative_url
    url_prefix + url
  end

  def publish(time = nil)
    update({ published_on: time || DateTime.now })
  end

  def published?
    !published_on.nil?
  end

  def css_class
    species.gsub('_', '-')
  end

  # This is stupid code to try and get Trademark approval for our business name.
  def introducing_techunwreck?
    url == 'techunwreck-a-division-of-jet-city-device-repair'
  end

  private

  def url_prefix
    blog_post? ? '/blog/' : '/'
  end

  def blog_post?
    species == 'blog_post'
  end

  def remove_leading_slash
    return unless url.try(:match, '^/')
    self.url = url[1..-1]
  end
end
