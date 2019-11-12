class FormTextField < FormItem
  private

  def form_item(field, placeholder)
    @form.text_field(field, class: 'form-control', placeholder: placeholder)
  end
end