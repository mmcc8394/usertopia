class FormItem
  def initialize(form)
    @form = form
  end

  def build_form_item(field, placeholder)
    str = start_form_group
    str += label_tag(field)
    str += form_item(field, placeholder)
    (str + end_form_group).html_safe
  end

  def text_field(field, placeholder)
    FormTextField.new(@form).build_form_item(field, placeholder)
  end

  def password(field, placeholder)
    FormPassword.new(@form).build_form_item(field, placeholder)
  end

  def submit(text)
    FormSubmit.new(@form).build_form_item(nil, text)
  end

  private

  def start_form_group
    '<div class="form-group">'
  end

  def label_tag(field)
    @form.label(field, class: 'sr-only')
  end

  def form_item(field, placeholder)
    'not implemented yet'
  end

  def end_form_group
    '</div>'
  end
end