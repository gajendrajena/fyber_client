require 'spec_helper'
require './app/models/offer'


describe 'Offer' do
  FYBER_CONFIG = {:api_key=>"b07a12df7d52e6c118e5d47d3f9e60135b109a1f", :appid=> 157, :device=>"2b6f0cc904d137be2e1730235f5664094b83", :format=>"json", :ip=>"109.235.143.113", :locale=>"de", 'uid' =>"foo", 'pub0' => "bar", 'offer_types' =>112}
  let(:client) { Offer.new FYBER_CONFIG }
  describe '#offers' do
    it 'should throw an error if required parameters were not set' do
      expect { client.offers }.to raise_error
    end

    it 'should not to throw an error if all required parameters were set' do
      expect { client.offers({page: 1, offer_types: FYBER_CONFIG['offer_types'], uid: FYBER_CONFIG['uid'], pub0: FYBER_CONFIG['pub0'] }) }.not_to raise_error
    end

    it 'should return an array' do
      expect( client.offers({ page: 1, offer_types: FYBER_CONFIG['offer_types'], uid: FYBER_CONFIG['uid'], pub0: FYBER_CONFIG['pub0'] })).to be_kind_of Array
    end
  end
end