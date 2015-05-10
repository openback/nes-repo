require './lib/gamesdb.rb'
require_relative './helpers.rb'

RSpec.configure do |c|
  c.include Helpers
  c.before(:each) do
    GamesDB.class_variable_set :@@platforms, nil
  end
end

RSpec.describe 'GamesDB' do
  context "with platforms" do
    it "can retrieve them" do
      allow(GamesDB).to receive(:query).and_return(Helpers::GamesDB::platforms_response)
      platforms = GamesDB.platforms
      expect(platforms.length).to eql(59)
      GamesDB.platforms
      expect(GamesDB).to have_received(:query).once
    end
  end

  # Since we mock the one method that uses this method, let's go ahead and test
  # the private method like a silly person
  context "with a hash" do
    it "creates a valid query string" do
      expect(GamesDB.send(:hash_to_querystring, {})).to eql('')
      expect(GamesDB.send(:hash_to_querystring, { :id => 1})).to eql('?id=1')
      expect(GamesDB.send(:hash_to_querystring, { :id => 'id'})).to eql('?id=id')
      expect(GamesDB.send(:hash_to_querystring, { :id => 1, :n => 2})).to eql('?id=1&n=2')
      expect(GamesDB.send(:hash_to_querystring, { :id => 1, :n => 2, :m => 3})).to eql('?id=1&n=2&m=3')
      expect(GamesDB.send(:hash_to_querystring, { :id => 1, :n => 'Me & you', :m => 3})).to eql('?id=1&n=Me+%26+you&m=3')
    end
  end

  context "with bad args" do
    it "should raise" do
      allow(GamesDB).to receive(:query).and_return(Helpers::GamesDB::platforms_response)

      expect{ GamesDB::find(:nescast, 'Ikaruga') }.to raise_error(ArgumentError)
      expect{ GamesDB::find(:nintendo_entertainment_system_nes) }.to raise_error(ArgumentError)
      expect{ GamesDB::find(:nintendo_entertainment_system_nes, '') }.to raise_error(ArgumentError)
      expect(GamesDB).to have_received(:query).once
    end
  end

  context "when it can't find the game" do
    it "should raise" do
      allow(GamesDB).to receive(:query).and_return(
        Helpers::GamesDB::platforms_response,
        Helpers::GamesDB::games_response
      )

      expect{ GamesDB::find(:nintendo_entertainment_system_nes, 'Nonononononononono') }.to raise_error(GamesDB::NotFoundError)
      expect(GamesDB).to have_received(:query).twice
    end
  end

  context "with a found game" do
    it "fetches game data when queried" do
      allow(GamesDB).to receive(:query).and_return(
        Helpers::GamesDB::platforms_response,
        Helpers::GamesDB::games_response,
        Helpers::GamesDB::game_response
      )

      game = GamesDB::find(:nintendo_entertainment_system_nes, "Mega Man")

      # Did it call out?
      expect(GamesDB).to have_received(:query).exactly(3).times
      expect(game[:release_date]).to eql(Date.parse("1987-12-17"))
      expect(game[:overview].length).to be(833)
      expect(game[:publisher]).to eq("Capcom")
      expect(game[:developer]).to eq("Capcom")
      expect(game[:co_op]).to eq(false)
      expect(game[:players]).to eq(1)
    end
  end
end
