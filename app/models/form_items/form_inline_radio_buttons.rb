class FormInlineRadioButtons < FormItem
  private

  def start_form_group
    '<div class="form-group ">'
  end

  def label_tag(field)
    ''
  end

  def form_item(field, options)
    options[:radio_options].inject('') do |str, item|
      str +
          '<div class="form-check form-check-inline">'.html_safe +
          @form.radio_button(:species, item, class: 'form-check-input') +
          ('<label class="form-check-label" for="post_species_' + item + '">').html_safe +
          item.humanize.downcase +
          '</label>'.html_safe + '</div>'.html_safe
    end
  end
end