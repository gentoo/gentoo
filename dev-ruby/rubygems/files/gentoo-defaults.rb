module Gem

  class << self
    def portage_gems_dir
      ConfigMap[:sitelibdir].gsub('site_ruby', 'gems')
    end

    def local_dir
      portage_gems_dir.gsub('@GENTOO_PORTAGE_EPREFIX@/usr', '@GENTOO_PORTAGE_EPREFIX@/usr/local')
    end
 
    undef :default_dir
    def default_dir
      Process.euid == 0 ? local_dir : user_dir
    end

    undef :default_path
    def default_path
      [user_dir, local_dir, portage_gems_dir]
    end

    undef :default_bindir
    def default_bindir
      Process.euid == 0 ? "@GENTOO_PORTAGE_EPREFIX@/usr/local/bin" : File.join(user_dir, 'bin')
    end

    undef :ruby_engine
    def ruby_engine
      if defined? RUBY_DESCRIPTION and RUBY_DESCRIPTION =~ /Ruby Enterprise Edition/
        "rubyee"
      else
        # Ruby 1.8 and Ruby 1.9.2_rc2 and later install here, and JRuby
        # rewrites that anyway.
        "ruby"
      end
    end

    def system_config_path
      "@GENTOO_PORTAGE_EPREFIX@/etc"
    end
  end
end
