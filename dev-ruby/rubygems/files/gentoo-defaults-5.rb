# frozen_string_literal: true

# Gentoo defaults for rubygems 3.x
#
# Gentoo policy is to install all manually installed code into
# /usr/local and to keep /usr managed by Gentoo. This policy file
# ensures that all manually installed gems using "gem install" as root
# are installed in /usr/local. Gentoo gems are installed in /usr.
module Gem
  class << self
    def gentoo_gems_dir
      RbConfig::CONFIG['sitelibdir'].gsub('site_ruby', 'gems')
    end

    def gentoo_bindir
      Process.euid.zero? ? '@GENTOO_PORTAGE_EPREFIX@/usr/local/bin' : File.join(user_home, 'bin')
    end

    def gentoo_local_dir
      gentoo_gems_dir.gsub('@GENTOO_PORTAGE_EPREFIX@/usr',
                           '@GENTOO_PORTAGE_EPREFIX@/usr/local')
    end

    def gentoo_install_dir
      Process.euid.zero? ? gentoo_local_dir : user_dir
    end

    undef :default_path
    def default_path
      path = []
      path << user_dir if user_home && File.exist?(user_home)
      path << default_dir
      path << vendor_dir if vendor_dir && File.directory?(vendor_dir)
      path << gentoo_local_dir
      path << gentoo_gems_dir
    end

    undef :operating_system_defaults
    def operating_system_defaults
      options = "--install-dir #{gentoo_install_dir} --bindir #{gentoo_bindir}"

      {
        'install' => options,
        'uninstall' => options,
        'update' => options
      }
    end
  end
end
