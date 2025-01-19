module MockHelpers
  def expect_method_object_call(object:, init_arguments:, method:, return_value: nil)
    object_double = instance_double(object)

    expect(object).to receive(:new).with(init_arguments)
      .and_return(object_double)

    expect(object_double).to receive(method)
      .and_return(return_value)
  end
end
