# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{csd}
  s.version = "0.1.11"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Technology Transfer Alliance Team"]
  s.date = %q{2010-08-04}
  s.default_executable = %q{ai}
  s.description = %q{CSD stands for Communication Systems Design and is a project of the Telecommunication Systems Laboratory (TSLab) of the Royal Institute of Technology in Stockholm, Sweden. Within CSD many software tools are used to build up various networks and services. This gem is supposed to automate processes to handle the compilation and installation of these software tools. Technology Transfer Alliance (TTA) is the project team, which maintains this code.}
  s.email = %q{mtoday11@gmail.com}
  s.executables = ["ai"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "COPYING",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/ai",
     "csd.gemspec",
     "lib/csd.rb",
     "lib/csd/application.rb",
     "lib/csd/application/decklink.rb",
     "lib/csd/application/decklink/about.yml",
     "lib/csd/application/decklink/base.rb",
     "lib/csd/application/decklink/options/install.rb",
     "lib/csd/application/default.rb",
     "lib/csd/application/default/base.rb",
     "lib/csd/application/minisip.rb",
     "lib/csd/application/minisip/about.yml",
     "lib/csd/application/minisip/base.rb",
     "lib/csd/application/minisip/component.rb",
     "lib/csd/application/minisip/component/core.rb",
     "lib/csd/application/minisip/component/ffmpeg.rb",
     "lib/csd/application/minisip/component/gnome.rb",
     "lib/csd/application/minisip/component/hdviper.rb",
     "lib/csd/application/minisip/component/plugins.rb",
     "lib/csd/application/minisip/component/x264.rb",
     "lib/csd/application/minisip/error.rb",
     "lib/csd/application/minisip/options/common.rb",
     "lib/csd/application/minisip/options/compile.rb",
     "lib/csd/application/minisip/options/package.rb",
     "lib/csd/application/minisip/phonebook_example.rb",
     "lib/csd/application/minisip/unix.rb",
     "lib/csd/application/minisip/unix/darwin.rb",
     "lib/csd/application/minisip/unix/linux.rb",
     "lib/csd/application/minisip/unix/linux/debian.rb",
     "lib/csd/application/minisip/unix/linux/debian/ubuntu10.rb",
     "lib/csd/application/opensips/about.yml",
     "lib/csd/applications.rb",
     "lib/csd/commands.rb",
     "lib/csd/container.rb",
     "lib/csd/error.rb",
     "lib/csd/extensions.rb",
     "lib/csd/extensions/core/array.rb",
     "lib/csd/extensions/core/dir.rb",
     "lib/csd/extensions/core/kernel.rb",
     "lib/csd/extensions/core/object.rb",
     "lib/csd/extensions/core/open_struct.rb",
     "lib/csd/extensions/core/option_parser.rb",
     "lib/csd/extensions/core/pathname.rb",
     "lib/csd/extensions/core/string.rb",
     "lib/csd/extensions/gem/platform.rb",
     "lib/csd/options_parser.rb",
     "lib/csd/path_container.rb",
     "lib/csd/user_interface.rb",
     "lib/csd/user_interface/base.rb",
     "lib/csd/user_interface/cli.rb",
     "lib/csd/user_interface/silent.rb",
     "lib/csd/vendor/active_support/MIT-LICENSE",
     "lib/csd/vendor/active_support/inflector.rb",
     "lib/csd/vendor/active_support/object_extensions.rb",
     "lib/csd/vendor/term/GPL2-LICENSE",
     "lib/csd/vendor/term/ansicolor.rb",
     "lib/csd/vendor/zentest/zentest_assertions.rb",
     "lib/csd/version.rb",
     "test/application/test_minisip.rb",
     "test/functional/test_application_base.rb",
     "test/functional/test_application_default.rb",
     "test/functional/test_applications.rb",
     "test/functional/test_cli.rb",
     "test/functional/test_commands.rb",
     "test/functional/test_csd.rb",
     "test/functional/test_options.rb",
     "test/helper.rb",
     "test/unit/test_container.rb",
     "test/unit/test_dir.rb",
     "test/unit/test_open_struct.rb",
     "test/unit/test_pathname.rb",
     "test/unit/test_platform.rb",
     "test/unit/test_string.rb"
  ]
  s.homepage = %q{http://github.com/csd/csd}
  s.post_install_message = %q{
============================================================

  Thank you for installing the TTA Automated Installer!

  You can run it by typing `ai´ in your command line.

  NOTE: On DEBIAN and UBUNTU the executable `ai´ is *maybe*
        not in your PATH by default. If that is the case,
        you can fix it by running this command:

  echo "export PATH=\$PATH:$(gem env | grep "E D" | sed "s/[^\w]* //")" >> ~/.bashrc;. ~/.bashrc

============================================================
}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Installation and compilation handler for software used in CSD projects.}
  s.test_files = [
    "test/application/test_minisip.rb",
     "test/functional/test_application_base.rb",
     "test/functional/test_application_default.rb",
     "test/functional/test_applications.rb",
     "test/functional/test_cli.rb",
     "test/functional/test_commands.rb",
     "test/functional/test_csd.rb",
     "test/functional/test_options.rb",
     "test/helper.rb",
     "test/unit/test_container.rb",
     "test/unit/test_dir.rb",
     "test/unit/test_open_struct.rb",
     "test/unit/test_pathname.rb",
     "test/unit/test_platform.rb",
     "test/unit/test_string.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end

