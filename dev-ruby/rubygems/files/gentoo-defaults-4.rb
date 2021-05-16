# frozen_string_literal: true

# Gentoo defaults for rubygems 3.x
#
# Gentoo policy is to install all manually installed code into
# /usr/local and to keep /usr managed by Gentoo. This policy file
# ensures that all manually installed gems using "gem install" are
# installed in /usr/local. Gentoo gems are installed in /usr.

# TODO: We used to manipulate the default_dir, but this no longer
# works since this is now the base for the new "default" gems that
# ruby 2.6 uses with irb. So default_dir should refer to the system
# default now. rubygems also provides various hooks so we may be able
# to use those to install gems in /usr/local by default in a less
# intrusive way.
module Gem

  class << self
    def portage_gems_dir
      RbConfig::CONFIG['sitelibdir'].gsub('site_ruby', 'gems')
    end

    def local_dir
      portage_gems_dir.gsub('@GENTOO_PORTAGE_EPREFIX@/usr',
                            '@GENTOO_PORTAGE_EPREFIX@/usr/local')
    end

    def install_dir
      Process.euid.zero? ? local_dir : user_dir
    end

    undef :default_path
    def default_path
      path = []
      path << user_dir if user_home && File.exist?(user_home)
      path << default_dir
      path << vendor_dir if vendor_dir && File.directory?(vendor_dir)
      path << local_dir
      path << portage_gems_dir
    end

    def system_config_path
      '@GENTOO_PORTAGE_EPREFIX@/etc'
    end

    # Set Gentoo defaults for gem commands
    begin
      undef :operating_system_defaults
    rescue NameError
      # Avoid either runtime errors or redefinition warnings since
      # this method is not present in all rubygem versions distributed
      # with dev-lang/ruby.
    end
    def operating_system_defaults
      {
        'install' => "--install-dir #{install_dir}",
        'uninstall' => "--install-dir #{install_dir}",
        'update' => "--install-dir #{install_dir}"
      }
    end

  end
end
