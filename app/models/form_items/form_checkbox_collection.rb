class FormCheckboxCollection < FormItem
  private

  def form_item(field, options)
    @form.collection_check_boxes(field, options[:collection], options[:value_function], options[:label_function])
  end
end