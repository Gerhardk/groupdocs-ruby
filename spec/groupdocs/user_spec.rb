require 'spec_helper'

describe GroupDocs::User do

  it_behaves_like GroupDocs::Api::Entity

  describe '.get!' do
    before(:each) do
      mock_api_server(load_json('user_profile_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::User object' do
      described_class.get!.should be_a(GroupDocs::User)
    end
  end

  describe '.update_account!' do
    before(:each) do
      mock_api_server(load_json('update_account'))
    end

    let!(:user) { GroupDocs::User.new }

    it 'accepts access credentials hash' do
      lambda do
        described_class.update_account!(user, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if user is not an instance of GroupDocs::User' do
      lambda { described_class.update_account!('user') }.should raise_error(ArgumentError)
    end

    it 'returns GroupDocs::User object' do
      described_class.update_account!(user).should be_a(GroupDocs::User)
    end
  end

  describe '.delete!' do
    before(:each) do
      mock_api_server(load_json('delete_account'))
    end

    let!(:user) { GroupDocs::User.new }

    it 'accepts access credentials hash' do
      lambda do
        described_class.delete!(user, :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'raises error if user is not an instance of GroupDocs::User' do
      lambda { described_class.delete!('user') }.should raise_error(ArgumentError)
    end

    it 'returns user guid' do
      described_class.delete!(user).should be_a(String)
    end
  end

  describe '.generate_embed_key!' do
    before(:each) do
      mock_api_server(load_json('user_embed_key'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.generate_embed_key!('test-area', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns new user embed key for defined area' do
      described_class.generate_embed_key!('test-area').should be_a(String)
    end
  end

  describe '.get_embed_key!' do
    before(:each) do
      mock_api_server(load_json('user_get_embed_key'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.get_embed_key!('test-area', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns user embed key for defined area' do
      described_class.get_embed_key!('test-area').should be_a(String)
    end
  end

  describe '.area!' do
    before(:each) do
      mock_api_server(load_json('user_area'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.area!('60a06eg8f23a49cf807977f1444fbdd8', :client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns area name by defined embed key' do
      described_class.area!('60a06eg8f23a49cf807977f1444fbdd8').should be_a(String)
    end
  end

  describe '.providers!' do
    before(:each) do
      mock_api_server(load_json('user_providers'))
    end

    it 'accepts access credentials hash' do
      lambda do
        described_class.providers!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::Storage::Provider' do
      providers = described_class.providers!
      providers.should be_an(Array)
      providers.each do |provider|
        provider.should be_a(GroupDocs::Storage::Provider)
      end
    end
  end

  describe '.login!' do
    before(:each) do
      mock_api_server(load_json('user_login'))
    end

    it 'works without access credentials hash' do
      lambda do
        described_class.login!('doe@john.com', 'password')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns GroupDocs::User object' do
      described_class.login!('doe@john.com', 'password').should be_a(GroupDocs::User)
    end
  end

  it { should have_accessor(:id)                 }
  it { should have_accessor(:guid)               }
  it { should have_accessor(:nickname)           }
  it { should have_accessor(:firstname)          }
  it { should have_accessor(:lastname)           }
  it { should have_accessor(:primary_email)      }
  it { should have_accessor(:private_key)        }
  it { should have_accessor(:password_salt)      }
  it { should have_accessor(:claimed_id)         }
  it { should have_accessor(:token)              }
  it { should have_accessor(:storage)            }
  it { should have_accessor(:photo)              }
  it { should have_accessor(:active)             }
  it { should have_accessor(:news_enabled)       }
  it { should have_accessor(:signed_up_on)       }
  it { should have_accessor(:color)              }
  it { should have_accessor(:customEmailMessage) }

  it { should alias_accessor(:first_name, :firstname)                    }
  it { should alias_accessor(:last_name, :lastname)                      }
  it { should alias_accessor(:custom_email_message, :customEmailMessage) }

  it { should have_alias(:pkey=, :private_key=)        }
  it { should have_alias(:pswd_salt=, :password_salt=) }
  it { should have_alias(:signedupOn=, :signed_up_on=) }

  describe '#access_rights' do
    it 'returns rights in human-readable format' do
      subject.instance_variable_set(:@access_rights, 15)
      subject.access_rights.should =~ [:export, :view, :proof, :download]
    end
  end

  describe '#access_rights=' do
    it 'converts rights in machine-readable format if array is passed' do
      subject.access_rights = %w(export view proof download)
      subject.instance_variable_get(:@access_rights).should == 15
    end

    it 'does nothing if not array is passed' do
      subject.access_rights = 15
      subject.instance_variable_get(:@access_rights).should == 15
    end
  end

  describe '#signed_up_on' do
    it 'returns converted to Time object Unix timestamp' do
      subject.signed_up_on = 1330450135000
      subject.signed_up_on.should == Time.at(1330450135)
    end
  end

  describe '#update!' do
    before(:each) do
      mock_api_server('{ "result": { "user_guid": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'uses hashed version of self as request body' do
      subject.should_receive(:to_hash)
      subject.update!
    end
  end

  describe '#users!' do
    before(:each) do
      mock_api_server(load_json('user_users_get'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.users!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array of GroupDocs::User objects' do
      users = subject.users!
      users.should be_an(Array)
      users.each do |user|
        user.should be_a(GroupDocs::User)
      end
    end
  end

  describe '#roles!' do
    before(:each) do
      mock_api_server(load_json('user_roles'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.roles!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'returns array' do
      roles = subject.roles!
      roles.should be_an(Array)
    end
  end

  describe '.update_password!' do
    before(:each) do
      mock_api_server('{ "result": { "user_guid": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update_password!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'works without access credentials hash' do
      lambda do
        described_class.update_password!('doe@john.com', 'password')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.reset_token!' do
    before(:each) do
      mock_api_server('{ "result": { "user": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.reset_token!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options credentials hash' do
      lambda do
        subject.reset_token!(:token => 'test')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.verif_token!' do
    before(:each) do
      mock_api_server('{ "result": { "user": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.verif_token!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options credentials hash' do
      lambda do
        subject.verif_token!(:token => 'test')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.claimed_token!' do
    before(:each) do
      mock_api_server('{ "result": { "user": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.claimed_token!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

    it 'accepts options credentials hash' do
      lambda do
        subject.claimed_token!(:token => 'test')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.get_profile!' do
    before(:each) do
      mock_api_server(load_json('user_get_profile'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.get_profile!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end

  end

  describe '#update_profile!' do
    before(:each) do
      mock_api_server(load_json('user_get_profile'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update_profile!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#create_user!' do
    before(:each) do
      mock_api_server(load_json('user_get_profile'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.users!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.create_login!' do
    before(:each) do
      mock_api_server(load_json('user_get_profile'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.users!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.update_alien_password!' do
    before(:each) do
      mock_api_server('{ "result": { "user_guid": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update_alien_password!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.reset_alien_password!' do
    before(:each) do
      mock_api_server('{ "result": { "user_name": "s8dfts8" }, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.reset_alien_password!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#update_provider!' do
    before(:each) do
      mock_api_server(load_json('user_providers'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.update_provider!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#add_provider!' do
    before(:each) do
      mock_api_server(load_json('user_providers'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.add_provider!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#user_roles!' do
    before(:each) do
      mock_api_server(load_json('user_roles'))
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.user_roles!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#set_user_roles!' do
    before(:each) do
      mock_api_server('{ "result": {}, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.set_user_roles!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#get_account!' do
    before(:each) do
      mock_api_server('{ "result": {}, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.get_account!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '#remove_account!' do
    before(:each) do
      mock_api_server('{ "result": {}, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.remove_account!(:client_id => 'client_id', :private_key => 'private_key')
      end.should_not raise_error(ArgumentError)
    end
  end

  describe '.download!' do
    before(:each) do
      mock_api_server('{ "result": {}, "status": "Ok" }')
    end

    it 'accepts access credentials hash' do
      lambda do
        subject.download!(:filename => 'test.txt', :render => 2)
      end.should_not raise_error(ArgumentError)
    end
  end

end
