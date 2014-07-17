require 'spec_helper'

describe "expect(...).to become_...(*args)" do
  before do
    WaitingRspecMatchers.default_wait_time = 0.6
    WaitingRspecMatchers.default_delay = 0.05
  end

  context "with non-existent matcher" do
    it "fails for non-existent matcher" do
      expect do
        expect { 1 }.to become_something(1)
      end.to raise_error(ArgumentError, "Method `something` doesn't exist. It was expected to exist and return instance of class that implements RSpec's matcher protocol.")
    end

    it "fails if method doesn't return rspec matcher" do
      expect do
        expect { 1 }.to become_to_s
      end.to raise_error(NoMethodError)
    end
  end

  context "with custom matcher" do
    it "passes if it passes for custom matcher" do
      expect { 1 }.to become_custom_eq(1)
    end

    it "fails if it fails for custom matcher" do
      expect do
        expect { 1 }.to become_custom_eq(2)
      end.to raise_error('something went wrong')
    end
  end

  context "with eq matcher" do
    it "passes if it passes for non-waiting matcher" do
      expect { 1 }.to become_eq(1)
    end
  end

  context "with include matcher" do
    it "passes if it passes for non-waiting matcher" do
      expect { [1] }.to become_include(1)
    end
  end

  context "with change matcher" do
    it "passes if it passes for non-waiting matcher" do
      a = 0
      expect { a += 1 }.to become_change{ a }.from(0).to(1)
    end

    it "doesn't pass if it doesn't pass for non-waiting matcher" do
      a = 0
      expect do
        expect { a += 2 }.to become_change{ a }.from(1).to(2)
      end.to raise_error(RSpec::Expectations::ExpectationNotMetError, "expected result to have initially been 1, but was 24")
    end

    it "passes if it passes after being invoked several times" do
      a = 0
      expect { a += 1 }.to become_change{ a }.from(3).to(4)
    end
  end

  context "with satisfy matcher" do
    it "passes if it passes for non-waiting matcher" do
      expect { 10 }.to become_satisfy { |v| v % 5 == 0 }
    end

    it "doesn't pass if it doesn't pass for non-waiting matcher" do
      expect { 7 }.not_to become_satisfy { |v| v % 5 == 0 }
    end
  end

  context "with exist matcher" do
    it "passes if it passes for non-waiting matcher" do
      a = nil
      expect { a }.to become_be_nil
    end

    it "doesn't pass if it doesn't pass for non-waiting matcher" do
      a = 0
      expect { a }.not_to become_be_nil
    end
  end

  it "doesn't pass if it doesn't pass for non-waiting matcher" do
    expect { 1 }.not_to become_eq(2)
  end

  it "fails when block isn't supplied" do
    error_class = (RUBY_ENGINE == 'rbx') ? ArgumentError : TypeError
    expect do
      expect(1).to become_eq(1)
    end.to raise_error(error_class)
  end

  it "waits up to default_wait_time for expectation to match" do
    start_time = Time.now
    expect do
      (start_time + 0.3 < Time.now)? 1 : 2
    end.to become_eq(1)
  end

  it "fails if expectation didn't match during wait time" do
    WaitingRspecMatchers.default_wait_time = 0.2

    start_time = Time.now
    expect do
      (start_time + 0.4 < Time.now)? 1 : 2
    end.not_to become_eq(1)
  end

  it "waits up to specified time if it's other than default_wait_time" do
    start_time = Time.now
    expect do
      (start_time + 0.9 < Time.now)? 1 : 2
    end.to become_eq(1).during(1.2)
  end

  it "allows to specify a different delay" do
    WaitingRspecMatchers.default_wait_time = 0.3
    start_time = Time.now
    expect do
      (start_time + 0.3 < Time.now)? 1 : 2
    end.to become_eq(1).delay(0.5)
  end

  it "allows to specify both wait time and delay" do
    WaitingRspecMatchers.default_wait_time = 0.3
    start_time = Time.now
    expect do
      (start_time + 0.3 < Time.now)? 1 : 2
    end.to become_eq(1).during(0.5).delay(0.1)
  end
end
