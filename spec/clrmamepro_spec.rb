require './lib/datfile/clrmamepro.rb'

RSpec.describe 'DatFile::Clrmamepro' do
	context 'With an invalid clrmamepro dat' do
		it 'should throw IOError exception' do
			expect{ dat = DatFile::Clrmamepro.new('util/ROMs/Mega Man.nes') }.to raise_exception(IOError)
		end
	end

	context 'With a valid clrmamepro dat' do
		before(:all) do
			@dat = DatFile::Clrmamepro.new('util/NES.dat')
		end

		after(:all) do
			@dat.close unless @dat.nil?
		end

		it 'parses all games' do
			expect(@dat.games.length).to eq(2671)
		end

		it 'returns all groups' do
			expect(@dat.groups.length).to eq(1962)
		end

		it 'returns a game object by name' do
			game = @dat.find_by_name 'Super Mario Bros. (World)'

			expect(game.group_name).to eq('Super Mario Bros.')
			expect(game.description).to eq('Super Mario Bros. (World)')
			expect(game.size).to eq(40960)
			expect(game.crc).to eq('D445F698')
			expect(game.md5).to eq('8E3630186E35D477231BF8FD50E54CDD')
			expect(game.sha1).to eq('FACEE9C577A5262DBE33AC4930BB0B58C8C037F7')
		end

		it 'returns a game object by crc' do
			game = @dat.find_by_crc 'D445F698'

			expect(game.name).to eq('Super Mario Bros. (World).nes')
			expect(game.group_name).to eq('Super Mario Bros.')
			expect(game.description).to eq('Super Mario Bros. (World)')
			expect(game.size).to eq(40960)
			expect(game.crc).to eq('D445F698')
			expect(game.md5).to eq('8E3630186E35D477231BF8FD50E54CDD')
			expect(game.sha1).to eq('FACEE9C577A5262DBE33AC4930BB0B58C8C037F7')
		end

		it 'returns the group name from a game' do
			expect(@dat.find_by_name('Super Mario Bros. (World)').group.size).to eq(2)
		end

		it 'should return an array of games' do
			games = @dat.group 'Super Mario Bros.'
			expect(games.size).to eq(2)

			expect(games[0].description).to eq('Super Mario Bros. (World)')
			expect(games[0].size).to eq(40960)
			expect(games[0].crc).to eq('D445F698')
			expect(games[0].md5).to eq('8E3630186E35D477231BF8FD50E54CDD')
			expect(games[0].sha1).to eq('FACEE9C577A5262DBE33AC4930BB0B58C8C037F7')

			expect(games[1].description).to eq('Super Mario Bros. (Europe) (Rev A)')
			expect(games[1].size).to eq(40960)
			expect(games[1].crc).to eq('9A2DB086')
			expect(games[1].md5).to eq('BA39DDE63AB209B1BC751E0535E72B18')
			expect(games[1].sha1).to eq('0C4992FC08D2278697339D3B48066E7B5F943598')
		end
	end
end
