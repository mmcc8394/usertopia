class FormPassword < FormItem
  private

  def form_item(field, placeholder)
    @form.password_field(field, class: 'form-control', placeholder: placeholder)
  end
end