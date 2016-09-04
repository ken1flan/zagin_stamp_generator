require File.expand_path '../../spec_helper.rb', __FILE__
require_relative '../../classes/text_image'
require 'mini_magick'

describe "ComponentImage" do
  describe "#initialize" do
    context "With no parameters" do
      let(:text_image) { TextImage.new }
      subject(:text) { text_image.text }
      subject(:font_name) { text_image.font_name }
      subject(:width) { text_image.width }
      subject(:height) { text_image.height }
      subject(:kittenize) { text_image.kittenize? }
      it "is set default values" do
        expect(text).to eql "LGTM!"
        expect(font_name).to eql "NotoSansCJKjp-Black"
        expect(width).to eq 280
        expect(height).to eq 280
        expect(kittenize).to be_truthy
      end
    end

    context "With text: 'Thank you!'" do
      let(:text_image) { TextImage.new(text: "Thank you!") }
      subject { text_image.text }
      it { is_expected.to eql "Thank you!"}
    end

    context "With font_name: 'keifont'" do
      let(:text_image) { TextImage.new(font_name: "keifont") }
      subject { text_image.font_name }
      it { is_expected.to eql "keifont"}
    end

    context "With width: 123" do
      let(:text_image) { TextImage.new(width: 123) }
      subject { text_image.width }
      it { is_expected.to eq 123}
    end

    context "With height: 123" do
      let(:text_image) { TextImage.new(height: 123) }
      subject { text_image.height }
      it { is_expected.to eq 123}
    end

    context "With kittendize: false" do
      let(:text_image) { TextImage.new(kittenize: false) }
      subject { text_image.kittenize? }
      it { is_expected.to be_falsy}
    end
  end

  describe ".valid_font_name? / .invalid_font_name?" do
    context "When font_name = 'keifont'" do
      subject(:valid?) { TextImage.valid_font_name?("keifont") }
      subject(:invalid?) { TextImage.invalid_font_name?("keifont") }
      it "is expected to be valid" do
        expect(valid?).to be_truthy
        expect(invalid?).to be_falsy
      end
    end

    context "When font_name = 'not_exist'" do
      subject(:valid?) { TextImage.valid_font_name?("not_exist") }
      subject(:invalid?) { TextImage.invalid_font_name?("not_exist") }
      it "is expected to be invalid" do
        expect(valid?).to be_falsy
        expect(invalid?).to be_truthy
      end
    end
  end

  describe "#imgage" do
    let(:text_image) { TextImage.new(text: "こんにちは、せかい。") }
    let(:test_image) { MiniMagick::Image.open(File.expand_path('../text_image/hello_world.png', __FILE__)) }
    subject { text_image.image.hash }
    xit { is_expected.to eql test_image.hash }
  end
end
