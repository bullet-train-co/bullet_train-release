namespace :bullet_train do
  desc "Release your package as both a Ruby gem and an npm package."
  task :release, ['flag'] do |task, args|
    dry_run = args.to_a.first == "dry-run"
    BulletTrain::Release.run(dry_run)
  end
end
