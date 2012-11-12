require 'spec_helper'

describe GroupDocs::Document::Annotation::Reviewer do

  it_behaves_like GroupDocs::Api::Entity

  describe '.all!' do
    before(:each) do
      mock_api_server(load_json('annotation_reviewers_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.all!(client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns an array of GroupDocs::Document::Annotation::Reviewer objects' do
      reviewers = described_class.all!
      reviewers.should be_an(Array)
      reviewers.each do |reviewer|
        reviewer.should be_a(GroupDocs::Document::Annotation::Reviewer)
      end
    end
  end

  describe '.set!' do
    before(:each) do
      mock_api_server(load_json('annotation_reviewers_get'))
    end

    let!(:reviewers) { [described_class.new(email_address: 'test@test.com')] }

    it 'accepts access credentials hash' do
      lambda do
        described_class.set!(reviewers, client_id: 'client_id', private_key: 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of reviewers' do
      reviewers.each do |reviewer|
        reviewer.should_receive(:to_hash)
      end
      described_class.set! reviewers
    end
  end

  it { should respond_to(:id)                  }
  it { should respond_to(:id=)                 }
  it { should respond_to(:guid)                }
  it { should respond_to(:guid=)               }
  it { should respond_to(:color)               }
  it { should respond_to(:color=)              }
  it { should respond_to(:emailAddress)        }
  it { should respond_to(:emailAddress=)       }
  it { should respond_to(:FullName)            }
  it { should respond_to(:FullName=)           }
  it { should respond_to(:accessRights)        }
  it { should respond_to(:accessRights=)       }
  it { should respond_to(:customEmailMessage)  }
  it { should respond_to(:customEmailMessage=) }

  it { should have_alias(:email_address, :emailAddress)                }
  it { should have_alias(:email_address=, :emailAddress=)              }
  it { should have_alias(:full_name, :FullName)                        }
  it { should have_alias(:full_name=, :FullName=)                      }
  it { should have_alias(:custom_email_message, :customEmailMessage)   }
  it { should have_alias(:custom_email_message=, :customEmailMessage=) }

  describe '#access_rights' do
    it 'returns rights in human-readable format' do
      subject.instance_variable_set(:@accessRights, 15)
      subject.access_rights.should =~ [:export, :view, :proof, :download]
    end
  end

  describe '#access_rights=' do
    it 'converts rights in machine-readable format' do
      subject.access_rights = %w(export view proof download)
      subject.instance_variable_get(:@accessRights).should == 15
    end
  end
end