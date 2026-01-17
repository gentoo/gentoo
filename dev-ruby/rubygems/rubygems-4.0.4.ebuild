# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

inherit ruby-ng prefix

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="https://rubygems.org/"

SRC_URI="https://github.com/ruby/rubygems/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="|| ( Ruby MIT )"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="server test"
RESTRICT="!test? ( test )"

PDEPEND="server? ( =dev-ruby/builder-3* )"

ruby_add_depend "virtual/ruby-ssl"

ruby_add_bdepend "
	test? (
		dev-ruby/json
		dev-ruby/minitest:5
		dev-ruby/rake
		dev-ruby/rdoc
		dev-ruby/test-unit
		dev-ruby/webrick
	)"

all_ruby_prepare() {
	# Remove unpackaged automatiek from Rakefile which stops it from working
	sed -i -e '/automatiek/ s:^:#:' -e '/Automatiek/,/^end/ s:^:#:' Rakefile || die

	mkdir -p lib/rubygems/defaults || die
	cp "${FILESDIR}/gentoo-defaults-5.rb" lib/rubygems/defaults/operating_system.rb || die

	eprefixify lib/rubygems/defaults/operating_system.rb

	# Disable broken tests when changing default values:
	sed -i -e '/test_default_path/,/^  end/ s:^:#:' test/rubygems/test_gem.rb || die
	sed -e '/test_initialize_\(path_with_defaults\|regexp_path_separator\)/aomit "gentoo"' \
		-i test/rubygems/test_gem_path_support.rb || die
	# Avoid test that won't work as json is also installed as plain ruby code
	sed -i -e '/test_realworld_\(\|upgraded_\)default_gem/aomit "gentoo"' test/rubygems/test_require.rb || die

	# Avoid test that requires additional utility scripts
	rm -f test/test_changelog_generator.rb || die

	# Avoid tests that require a network connection (for crates.io or other downloads)
	rm -f test/rubygems/test_gem_ext_cargo_builder.rb || die
	sed -e '/test_gem_exec_gem_uninstall/aomit "requires network"' \
		-i test/rubygems/test_gem_commands_exec_command.rb || die

	# Avoid tests with newer rdoc versions. These tests have been disabled upstream.
	sed -e '/test_execute_rdoc/aomit "no longer needed with rdoc 6.9.0"' \
		-i test/rubygems/test_gem_commands_{install,update}_command.rb || die

	# Update manifest after changing files to avoid a test failure. Set
	# RUBYLIB to ensure that we consistently use the new code for
	# rubygems and the bundled bundler.
	if use test; then
		ruby -I lib -S rake update_manifest || die
	fi
}

each_ruby_compile() {
	# Not really a build but...
	sed -i -e 's:#!.*:#!'"${RUBY}"':' exe/gem
}

each_ruby_test() {
	# Unset RUBYOPT to avoid interferences, bug #158455 et. al.
	#unset RUBYOPT

	if [[ "${EUID}" -ne "0" ]]; then
		RUBYLIB="$(pwd)/lib${RUBYLIB+:${RUBYLIB}}" ${RUBY} --disable-gems -I.:lib:test:bundler/lib \
			-e 'require "rubygems"; Dir["test/**/test_*.rb"].each { require _1 }' || die "tests failed"
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

	newbin exe/gem $(basename ${RUBY} | sed -e 's:ruby:gem:')
}

all_ruby_install() {
	dodoc CHANGELOG.md README.md

	if use server; then
		newinitd "${FILESDIR}/init.d-gem_server2" gem_server
		newconfd "${FILESDIR}/conf.d-gem_server" gem_server
	fi
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"/usr/bin/gem) ]] ; then
		eselect ruby set $(eselect --brief --colour=no ruby show | head -n1)
	fi

	ewarn
	ewarn "To switch between available Ruby profiles, execute as root:"
	ewarn "\teselect ruby set ruby(30|31|...)"
	ewarn
}
