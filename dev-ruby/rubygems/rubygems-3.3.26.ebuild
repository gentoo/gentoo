# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30 ruby31"

inherit ruby-ng prefix

DESCRIPTION="Centralized Ruby extension management system"
HOMEPAGE="https://rubygems.org/"
LICENSE="|| ( Ruby MIT )"

SRC_URI="https://github.com/rubygems/rubygems/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
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
	sed -i -e '/test_initialize_\(path_with_defaults\|regexp_path_separator\)/aomit "gentoo"' test/rubygems/test_gem_path_support.rb || die
	# Avoid test that won't work as json is also installed as plain ruby code
	sed -i -e '/test_realworld_\(\|upgraded_\)default_gem/aomit "gentoo"' test/rubygems/test_require.rb || die

	# Avoid test that requires additional utility scripts
	rm -f test/test_changelog_generator.rb || die

	# Avoid tests that require a network connection (for crates.io)
	rm -f test/rubygems/test_gem_ext_cargo_builder.rb || die

	# Update manifest after changing files to avoid a test failure
	if use test; then
		rake update_manifest || die
	fi
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
