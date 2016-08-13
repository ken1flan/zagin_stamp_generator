require 'dotenv'
require 'rom'
require 'rom/sql/rake_task'

Dotenv.load

rom = ROM.container(:sql, "#{ENV['DATABASE_URL']}")
gateway = rom.gateways[:default]

namespace :db do
  task :setup do
    puts 'hello'
  end
end
