Jenkins::Plugin::Specification.new do |plugin|
  plugin.name = "ci-skip"
  plugin.display_name = "Ci Skip Plugin"
  plugin.version = '0.0.1'
  plugin.description = 'Commits that have [ci skip] anywhere in the commit messages will be ignored.'

  # You should create a wiki-page for your plugin when you publish it, see
  # https://wiki.jenkins-ci.org/display/JENKINS/Hosting+Plugins#HostingPlugins-AddingaWikipage
  # This line makes sure it's listed in your POM.
  plugin.url = 'https://wiki.jenkins-ci.org/display/JENKINS/Ci+Skip+Plugin'

  # The first argument is your user name for jenkins-ci.org.
  plugin.developed_by "banyan", "Kohei Hasegawa <ameutau@gmail.com>"

  # This specifies where your code is hosted.
  # Alternatives include:
  #  :github => 'myuser/ci-skip-plugin' (without myuser it defaults to jenkinsci)
  #  :git => 'git://repo.or.cz/ci-skip-plugin.git'
  #  :svn => 'https://svn.jenkins-ci.org/trunk/hudson/plugins/ci-skip-plugin'
  plugin.uses_repository :github => "banyan/jenkins-ci-skip-plugin"

  # This is a required dependency for every ruby plugin.
  plugin.depends_on 'ruby-runtime', '0.12'
end
