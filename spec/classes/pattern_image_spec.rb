require File.expand_path '../../spec_helper.rb', __FILE__

describe "PatternImage" do
  let(:pattern_image){ PatternImage.new('text') }
  let(:image_dir){ File.expand_path('../../../images/patterns/', __FILE__) }

  describe "#initialize" do
    subject { pattern_image.id }
    it { is_expected.to eql 'text' }
  end

  describe "#path" do
    subject { pattern_image.path }
    it { is_expected.to eql "#{image_dir}/text.png" }
  end

  describe "#valid?" do
    context 'When id = top' do
      let(:pattern_image){PatternImage.new('zagin')}
      subject { pattern_image.valid? }
      it { is_expected.to be_truthy }
    end

    context 'When id = not_exist' do
      let(:pattern_image){PatternImage.new('not_exist')}
      subject { pattern_image.valid? }
      it { is_expected.to be_falsy }
    end
  end
end
