# frozen_string_literal: true

require_relative "release/version"
require "rails/railtie"

module BulletTrain
  module Release
    class Error < StandardError; end

    class LoadTasks < Rails::Railtie
      rake_tasks do
        rake_file_path = "#{(__dir__).gsub("/lib/bullet_train", "")}/tasks/bullet_train-release.rake"
        load rake_file_path
      end
    end

    def self.run(dry_run)
      unless `git branch | grep main`.chomp == "* main"
        puts "You can only release from the `main` branch."
        exit
      end

      puts "Checking whether we're up-to-date with `origin/main`."

      stream "git fetch origin"
      puts output = `git merge origin main`

      unless output.include?("Already up to date")
        puts "Sorry, `main` needed to be up-to-date with `origin/main` before we release, and it looks like it wasn't. We attempted a merge, but you should confirm that went OK before running `rake app:bullet_train:release` again!"
        exit
      end

      puts "Bumping Ruby gem version."
      puts output = `bump patch`
      version = output.chomp.lines.last.chomp
      puts "Bumped to #{version}."

      # Update the `package.json` version.
      puts "Bumping npm package version."
      text = File.read("package.json")
      new_contents = text.gsub(/\"version\": \".*\"/, "\"version\": \"#{version}\"")
      File.open("package.json", "w") { |file| file.puts new_contents }
      unless dry_run
        `git add ./package.json`
        stream "git commit -m \"Bumping npm package to #{version}.\""
      end

      unless dry_run
        puts "OK! Versions are all bumped. Pushing those to GitHub."
        stream "git push origin main"
      end

      puts "Now we'll build the Ruby gem."
      puts output = `gem build`
      gem_file = output.chomp.lines.last.chomp.split.last
      puts gem_file

      puts "Now we'll build the npm package."
      puts `yarn build`
      puts output = `yarn pack`
      npm_file = output.chomp.lines[1].split("/").last.split("\"").first
      puts npm_file

      puts "OK, this last piece we can't do manually (because of 2FA) so copy and the following:"
      puts ""
      puts "  gem push #{gem_file}"
      puts "  yarn publish #{npm_file} --new-version #{version}"
      puts "  rm #{gem_file} #{npm_file}"
      puts ""
    end

    private

    def self.stream(command, prefix = "  ")
      puts ""
      IO.popen(command) do |io|
        while (line = io.gets) do
          puts "#{prefix}#{line}"
        end
      end
      puts ""
    end
  end
end
