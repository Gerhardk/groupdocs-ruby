require 'spec_helper'

describe GroupDocs::Storage do
  describe '#info!' do
    before(:each) do
      mock_api_server(load_json('storage_info'))
    end

    it 'returns a hash of information' do
      described_class.info!.should be_a(Hash)
    end

    it 'converts total space to MB' do
      described_class.info![:total_space].should == "1024 MB"
    end

    it 'converts available space to MB' do
      described_class.info![:available_space].should == "1020 MB"
    end
  end
end