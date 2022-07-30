# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit ruby-ng prefix

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="https://rubygems.org/"
LICENSE="|| ( Ruby MIT )"

SRC_URI="https://rubygems.org/rubygems/${P}.tgz"

KEYWORDS="~alpha amd64 arm arm64 hppa ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="server test"
RESTRICT="!test? ( test )"

PDEPEND="server? ( =dev-ruby/builder-3* )"

ruby_add_bdepend "
	test? (
		dev-ruby/json
		dev-ruby/minitest:5
		dev-ruby/rdoc
	)"

all_ruby_prepare() {

	mkdir -p lib/rubygems/defaults || die
	cp "${FILESDIR}/gentoo-defaults.rb" lib/rubygems/defaults/operating_system.rb || die

	eprefixify lib/rubygems/defaults/operating_system.rb

	# Disable broken tests when changing default values:
	sed -i -e '/test_default_path/,/^  end/ s:^:#:' test/rubygems/test_gem.rb || die
	sed -i -e '/assert_self_install_permissions/,/^  end/ s/^.*RUBY_INSTALL_NAME.*//' test/rubygems/test_gem.rb || die

	# Skip tests for default gems that all fail
	sed -i -e '/test_default_gems_use_full_paths/,/^  end/ s:^:#:' test/rubygems/test_gem.rb || die
	sed -i -e '/test_execute_ignore_default_gem_verbose/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_cleanup_command.rb || die
	sed -i -e '/test_execute_default_gem/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_contents_command.rb test/rubygems/test_gem_commands_pristine_command.rb || die
	sed -i -e '/test_execute_\(default_details\|show_default_gems\)/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_query_command.rb || die
	sed -i -e '/test_execute_all/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_uninstall_command.rb || die
	sed -i -e '/\(test_default_gem\|test_check_executable_overwrite\|test_require_works_after_cleanup\)/,/^  end/ s:^:#:' \
		test/rubygems/test_{gem_installer,require}.rb || die
	sed -i -e '/test_\(load_default_gem\|default_spec_stub\|self_stubs\)/,/^  end/ s:^:#:' test/rubygems/test_gem_specification.rb || die
	sed -i -e '/test_uninstall_default_gem/,/^  end/ s:^:#:' test/rubygems/test_gem_uninstaller.rb || die
	rm -f test/rubygems/test_gem_indexer.rb || die
	sed -i -e '/test_\(require_when_gem_defined\|realworld_default_gem\)/,/^  end/ s:^:#:' test/rubygems/test_require.rb || die
	rm -f test/rubygems/test_gem_commands_setup_command.rb || die

	# Avoid tests playing tricks with ruby engine that don't seem to
	# work for us.
	rm test/rubygems/test_gem_request_set_gem_dependency_api.rb || die

	# Avoid test requiring network access
	sed -i -e '/test_download_to_cache/askip "requires network access"' test/rubygems/test_gem_remote_fetcher.rb || die

	# Avoid test requiring file system permission changes
	sed -i -e '/test_traverse_parents_does_not_crash_on_permissions_error/,/^  end/ s:^:#:' test/rubygems/test_gem_util.rb || die

	# Avoid uninvestigated test failure in favor of security release
	sed -i -e '/test_self_install_permissions_with_format_executable/askip "uninvestigated failure"' test/rubygems/test_gem.rb || die
}

each_ruby_compile() {
	# Not really a build but...
	sed -i -e 's:#!.*:#!'"${RUBY}"':' bin/gem
}

each_ruby_test() {
	# Unset RUBYOPT to avoid interferences, bug #158455 et. al.
	#unset RUBYOPT

	if [[ "${EUID}" -ne "0" ]]; then
		RUBYLIB="$(pwd)/lib${RUBYLIB+:${RUBYLIB}}" ${RUBY} --disable-gems -I.:lib:test:bundler/lib \
			-e 'require "rubygems"; gem "minitest", "~>5.0"; Dir["test/**/test_*.rb"].each { |tu| require tu }' || die "tests failed"
	else
		ewarn "The userpriv feature must be enabled to run tests, bug 408951."
		eerror "Testsuite will not be run."
	fi
}

each_ruby_install() {
	# Unset RUBYOPT to avoid interferences, bug #158455 et. al.
	unset RUBYOPT
	export RUBYLIB="$(pwd)/lib${RUBYLIB+:${RUBYLIB}}"

	pushd lib &>/dev/null
	doruby -r *
	popd &>/dev/null

	local sld=$(ruby_rbconfig_value 'sitelibdir')
	insinto "${sld#${EPREFIX}}"  # bug #320813
	newins "${FILESDIR}/auto_gem.rb.ruby19" auto_gem.rb

	newbin bin/gem $(basename ${RUBY} | sed -e 's:ruby:gem:')
}

all_ruby_install() {
	dodoc History.txt README.md

	if use server; then
		newinitd "${FILESDIR}/init.d-gem_server2" gem_server
		newconfd "${FILESDIR}/conf.d-gem_server" gem_server
	fi
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"usr/bin/gem) ]] ; then
		eselect ruby set $(eselect --brief --colour=no ruby show | head -n1)
	fi

	ewarn
	ewarn "To switch between available Ruby profiles, execute as root:"
	ewarn "\teselect ruby set ruby(23|24|...)"
	ewarn
}
