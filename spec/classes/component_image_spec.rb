require File.expand_path '../../spec_helper.rb', __FILE__
require_relative '../../classes/component_image'
require 'mini_magick'

describe "ComponentImage" do
  context "With PatternImage" do
    let(:PatternImage) do
      Class.new(ComponentImage) do
        def self.image_dir
          File.expand_path('../../images/patterns/', __FILE__)
        end
      end
    end
    let(:pattern_image){ PatternImage.new('zagin') }
    let(:image_dir){ File.expand_path('../../../images/patterns/', __FILE__) }

    describe "#initialize" do
      subject { pattern_image.id }
      it { is_expected.to eql 'zagin' }
    end

    describe "#path" do
      subject { pattern_image.path }
      it { is_expected.to eql "#{image_dir}/zagin.png" }
    end

    describe "#valid? / #invalid?" do
      subject(:valid?) { pattern_image.valid? }
      subject(:invalid?) { pattern_image.invalid? }

      context 'When id = zagin' do
        let(:pattern_image){PatternImage.new('zagin')}
        it "expects valid returns truthy and invalid returns falsy" do
          expect(valid?).to be_truthy
          expect(invalid?).to be_falsy
        end
      end

      context 'When id = not_exist' do
        let(:pattern_image){PatternImage.new('not_exist')}
        it "expects valid returns falsy and invalid returns truthy" do
          expect(valid?).to be_falsy
          expect(invalid?).to be_truthy
        end
      end
    end

    describe "#image" do
      subject { pattern_image.image }
      it { is_expected.to eql MiniMagick::Image.open("#{image_dir}/zagin.png")}
    end

    describe ".valid? / .invalid?" do
      context 'When id = zagin' do
        subject(:valid?) { PatternImage.valid?('zagin') }
        subject(:invalid?) { PatternImage.invalid?('zagin') }
        it "expects valid returns truthy and invalid returns falsy" do
          expect(valid?).to be_truthy
          expect(invalid?).to be_falsy
        end
      end

      context 'When id = not_exist' do
        subject(:valid?) { PatternImage.valid?('not_exist') }
        subject(:invalid?) { PatternImage.invalid?('not_exist') }
        it "expects valid returns falsy and invalid returns truthy" do
          expect(valid?).to be_falsy
          expect(invalid?).to be_truthy
        end
      end
    end
  end
end
