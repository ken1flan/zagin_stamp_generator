require_relative '../spec_helper.rb'
require_relative '../../classes/stamp'

describe Stamp do
  before { Stamp.reset }

  describe ".setup?" do
    subject { Stamp.setup? }

    context "When Stamp doesn't load yaml" do
      it { is_expected.to be_falsy }
    end

    context "When Stamp loaded yaml" do
      before { Stamp.load(File.expand_path '../../../stamps.yml', __FILE__) }

      it { is_expected.to be_truthy }
    end
  end

  describe ".create_by_id" do

    context "When Stamp doesn't load yaml" do
      let(:id){ 'something' }
      it "throws exception" do
        expect { Stamp.create_by_id('something') }.to raise_exception(RuntimeError, "doesn't load default data")
      end
    end

    context "When Stamp loaded yaml" do
      before { Stamp.load(File.expand_path '../../../stamps.yml', __FILE__) }

      context "When id is not exist" do
        let(:id){ "not_exist" }

        it "throws exception" do
          expect { Stamp.create_by_id(id) }.to raise_exception(RuntimeError, "not found not_exist")
        end
      end

      context "When id is exist" do
        let(:id){ "happi_coat" }

        it "is found" do
          expect(Stamp.create_by_id(id).id).to be_eql "happi_coat"
        end
      end
    end
  end

  describe ".list" do
    context "When Stamp doesn't load yaml" do
      it "throws exception" do
        expect { Stamp.create_by_id('something') }.to raise_exception(RuntimeError, "doesn't load default data")
      end
    end

    context "When Stamp loaded yaml" do
      before { Stamp.load(File.expand_path '../../../stamps.yml', __FILE__) }

      it "returns stamp list" do
        Stamp.list.each do |key, stamp|
          expect(stamp.class.name).to be_eql "Stamp"
        end
      end
    end
  end
end
