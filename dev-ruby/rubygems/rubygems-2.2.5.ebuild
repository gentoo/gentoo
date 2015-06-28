# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubygems/rubygems-2.2.5.ebuild,v 1.2 2015/06/28 08:10:54 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20"

inherit ruby-ng prefix

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="http://rubyforge.org/projects/rubygems/"
LICENSE="|| ( Ruby MIT )"

SRC_URI="http://production.cf.rubygems.org/rubygems/${P}.tgz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE="server test"

PDEPEND="server? ( >=dev-ruby/builder-2.1 )"

ruby_add_bdepend "
	test? (
		>=dev-ruby/minitest-4:0
		dev-ruby/rdoc
	)"

all_ruby_prepare() {
	mkdir -p lib/rubygems/defaults || die
	cp "${FILESDIR}/gentoo-defaults.rb" lib/rubygems/defaults/operating_system.rb || die

	eprefixify lib/rubygems/defaults/operating_system.rb

	# Disable broken tests when changing default values:
	sed -i -e '/test_check_executable_overwrite_default_bin_dir/,/^  end/ s:^:#:' test/rubygems/test_gem_installer.rb || die

	# Remove a test that fails when yard is installed.
	sed -i -e '/test_self_attribute_names/,/^  end/ s:^:#:' test/rubygems/test_gem_specification.rb || die

	# Skip tests for default gems that all fail
	sed -i -e '/test_default_gems_use_full_paths/,/^  end/ s:^:#:' test/rubygems/test_gem.rb || die
	sed -i -e '/test_execute_ignore_default_gem_verbose/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_cleanup_command.rb || die
	sed -i -e '/test_execute_default_gem/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_contents_command.rb test/rubygems/test_gem_commands_pristine_command.rb || die
	sed -i -e '/test_execute_default_details/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_query_command.rb || die
	sed -i -e '/test_execute_all/,/^  end/ s:^:#:' test/rubygems/test_gem_commands_uninstall_command.rb || die
	sed -i -e '/test_load_default_gem/,/^  end/ s:^:#:' test/rubygems/test_gem_specification.rb || die
	sed -i -e '/test_uninstall_default_gem/,/^  end/ s:^:#:' test/rubygems/test_gem_uninstaller.rb || die
	sed -i -e '/test_alien_default/,/^  end/ s:^:#:' test/rubygems/test_gem_validator.rb || die

	# Avoid tests playing tricks with ruby engine that don't seem to
	# work for us.
	rm test/rubygems/test_gem_request_set_gem_dependency_api.rb || die

	# Avoid test requiring network access
	sed -i -e '/test_download_to_cache/askip "requires network access"' test/rubygems/test_gem_remote_fetcher.rb || die
}

each_ruby_compile() {
	# Not really a build but...
	sed -i -e 's:#!.*:#!'"${RUBY}"':' bin/gem
}

each_ruby_test() {
	# Unset RUBYOPT to avoid interferences, bug #158455 et. al.
	#unset RUBYOPT

	if [[ "${EUID}" -ne "0" ]]; then
		RUBYLIB="$(pwd)/lib${RUBYLIB+:${RUBYLIB}}" ${RUBY} -I.:lib:test \
			-e 'Dir["test/**/test_*.rb"].each { |tu| require tu }' || die "tests failed"
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
	newins "${FILESDIR}/auto_gem.rb.ruby19" auto_gem.rb || die

	newbin bin/gem $(basename ${RUBY} | sed -e 's:ruby:gem:') || die
}

all_ruby_install() {
	dodoc History.txt README.rdoc

	if use server; then
		newinitd "${FILESDIR}/init.d-gem_server2" gem_server || die "newinitd failed"
		newconfd "${FILESDIR}/conf.d-gem_server" gem_server || die "newconfd failed"
	fi
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"usr/bin/gem) ]] ; then
		eselect ruby set $(eselect --brief --no-color ruby show | head -n1)
	fi

	ewarn
	ewarn "To switch between available Ruby profiles, execute as root:"
	ewarn "\teselect ruby set ruby(19|20|...)"
	ewarn
}

pkg_postrm() {
	ewarn "If you have uninstalled dev-ruby/rubygems, Ruby applications are unlikely"
	ewarn "to run in current shells because of missing auto_gem."
	ewarn "Please run \"unset RUBYOPT\" in your shells before using ruby"
	ewarn "or start new shells"
	ewarn
	ewarn "If you have not uninstalled dev-ruby/rubygems, please do not unset "
	ewarn "RUBYOPT"
}
