# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27"

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

ruby_add_depend "virtual/ruby-ssl"

ruby_add_bdepend "
	test? (
		dev-ruby/json
		dev-ruby/minitest:5
		dev-ruby/rake
		dev-ruby/rdoc
	)"

all_ruby_prepare() {

	mkdir -p lib/rubygems/defaults || die
	cp "${FILESDIR}/gentoo-defaults-4.rb" lib/rubygems/defaults/operating_system.rb || die

	eprefixify lib/rubygems/defaults/operating_system.rb

	# Disable broken tests when changing default values:
	sed -i -e '/test_default_path/,/^  end/ s:^:#:' test/rubygems/test_gem.rb || die
	# Avoid test that won't work as json is also installed as plain ruby code
	sed -i -e '/test_realworld_default_gem/askip "gentoo"' test/rubygems/test_require.rb || die

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
	dodoc History.txt README.md

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
	ewarn "\teselect ruby set ruby(25|26|...)"
	ewarn
}
