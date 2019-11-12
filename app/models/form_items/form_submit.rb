class FormSubmit < FormItem
  private

  def label_tag(field)
    ''
  end

  def form_item(field, placeholder)
    @form.submit(placeholder, class: 'btn btn-primary')
  end
end