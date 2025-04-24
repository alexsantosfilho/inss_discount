require 'rails_helper'

RSpec.describe Inss::CalculationService do
  describe ".call" do
    it "calculates discount for minimum wage" do
      expect(described_class.call(1045.00)).to eq(78.38)
    end

    it "calculates discount for salary in second range" do
      expect(described_class.call(2000.00)).to be_within(0.01).of(164.32)
    end

    it "calculates discount for salary in third range" do
      expect(described_class.call(3000.00)).to be_within(0.01).of(281.63)
    end

    it "calculates discount for salary in fourth range" do
      expect(described_class.call(5000.00)).to be_within(0.01).of(558.95)
    end

    it "calculates discount for salary above maximum" do
      expect(described_class.call(10000.00)).to be_within(0.01).of(713.09)
    end
  end
end
