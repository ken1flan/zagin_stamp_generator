require_relative '../spec_helper.rb'
require_relative '../../classes/color'

describe Color do
  before { Color.reset }

  describe ".setup?" do
    subject { Color.setup? }

    context "When Color doesn't load yaml" do
      it { is_expected.to be_falsy }
    end

    context "When Color loaded yaml" do
      before { Color.load(File.expand_path '../../../colors.yml', __FILE__) }

      it { is_expected.to be_truthy }
    end
  end

  describe ".find_by_id" do
    context "When Color doesn't load yaml" do
      let(:id){ 'something' }
      it "throws exception" do
        expect { Color.find_by_id('something') }.to raise_exception(RuntimeError, "doesn't load default data")
      end
    end

    context "When Color loaded yaml" do
      before { Color.load(File.expand_path '../../../colors.yml', __FILE__) }

      context "When id is not exist" do
        let(:id){ "not_exist" }

        it "throws exception" do
          expect { Color.find_by_id(id) }.to raise_exception(RuntimeError, "not found not_exist")
        end
      end

      context "When id is exist" do
        let(:id){ "white" }

        it "is found" do
          expect(Color.find_by_id(id).id).to be_eql "white"
        end
      end
    end
  end

  describe ".list" do
    context "When Color doesn't load yaml" do
      it "throws exception" do
        expect { Color.list }.to raise_exception(RuntimeError, "doesn't load default data")
      end
    end

    context "When Color loaded yaml" do
      before { Color.load(File.expand_path '../../../colors.yml', __FILE__) }

      it "returns color list" do
        Color.list.each do |key, color|
          expect(color.class.name).to be_eql "Color"
        end
      end
    end
  end
end
