require "spec_helper"

describe Activerecord::Oracle::Queue::VERSION do
  it "is a string" do
    expect(Activerecord::Oracle::Queue::VERSION).to be_a(String)
  end
end
