require 'rails_helper'

RSpec.describe Post, type: :model do
  before(:each) do
    @user = User.create!({ first_name: 'Jane', last_name: 'Doe',
                           email: 'user@example.com', password: 'password',
                           roles: [ 'admin' ]
                         })

    @post = Post.new({ title: 'Some Web Page',
                       species: 'web_page',
                       url: 'some-url',
                       published_by: @user.id,
                       meta_description: 'some meta description here',
                       content: '<b>Some stuff here.</b>' })
  end

  it 'valid' do
    expect(@post.save).to be(true)
  end

  it 'user association' do
    @post.save!
    expect(Post.find(@post.id).publisher.full_name).to eq('Jane Doe')
  end

  context 'invalid' do
    it 'title is nil' do
      @post.title = nil
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:title]).to include("can't be blank")
    end

    it 'title is blank' do
      @post.title = ''
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:title]).to include("can't be blank")
    end

    it 'url is nil' do
      @post.url = nil
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:url]).to include("can't be blank")
    end

    it 'url is blank' do
      @post.url = ''
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:url]).to include("can't be blank")
    end

    it 'url is unique' do
      @post.save!
      bad_post = Post.new({ species: 'web_page', url: 'some-url', content: '<b>Some more stuff here.</b>' })
      expect(bad_post.valid?).to eq(false)
      expect(bad_post.errors[:url]).to include("has already been taken")
    end

    it 'species is nil' do
      @post.species = nil
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:species]).to include("can't be blank")
    end

    it 'species is blank' do
      @post.species = ''
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:species]).to include("can't be blank")
    end

    it 'species is invalid type' do
      @post.species = 'foobar'
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:species]).to include('is not included in the list')
    end

    it 'meta_description is nil' do
      @post.meta_description = nil
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:meta_description]).to include("can't be blank")
    end

    it 'meta_description is blank' do
      @post.meta_description = ''
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:meta_description]).to include("can't be blank")
    end

    it 'content is nil' do
      @post.content = nil
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:content]).to include("can't be blank")
    end

    it 'content is blank' do
      @post.content = ''
      expect(@post.valid?).to eq(false)
      expect(@post.errors[:content]).to include("can't be blank")
    end
  end

  context 'url prefix' do
    it 'web page' do
      expect(@post.relative_url).to eq('/some-url')
    end

    it 'blog post' do
      @post.species = 'blog_post'
      expect(@post.relative_url).to eq('/blog/some-url')
    end
  end

  context 'publishing' do
    before(:each) { @post.save! }

    it 'published by set correctly' do
      expect(@post.publisher.full_name).to eq('Jane Doe')
    end

    it 'unpublished' do
      expect(@post.published_on).to be_nil
    end

    it 'published' do
      @post.publish
      expect(@post.published?).to be(true)
    end

    it 'published right now' do
      @post.publish
      expect(@post.published_on).to be_within(2.seconds).of DateTime.now
    end

    it 'published in the future' do
      @post.publish(DateTime.now + 1.week)
      expect(@post.published_on).to be_within(2.seconds).of(DateTime.now + 1.week)
    end
  end
end
