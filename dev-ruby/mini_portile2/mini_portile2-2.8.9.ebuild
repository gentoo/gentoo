# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

inherit ruby-fakegem

DESCRIPTION="Simplistic port-like solution for developers"
HOMEPAGE="https://github.com/flavorjones/mini_portile"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos"
IUSE="test"

BDEPEND="test? ( app-crypt/gnupg dev-build/cmake )"

ruby_add_bdepend "test? (
	dev-ruby/minitar:0
	dev-ruby/minitest:5
	dev-ruby/minitest-hooks
	dev-ruby/net-ftp
	dev-ruby/webrick
)"

all_ruby_prepare() {
	# Avoid tests that expect gcc to be the main compiler, which we
	# cannot guarantee.
	sed -e '/test_configure_defaults_with/askip("Requires gcc to be the C/C++ compiler.")' \
		-i test/test_cmake.rb || die

	# Keep gpg from creating a default common.conf with broken keyboxd support.
	mkdir -m 700 "${HOME}/.gnupg" || die
	touch "${HOME}/.gnupg/common.conf" || die
}

each_ruby_test() {
	${RUBY} -w -W2 -I. -Ilib -e 'gem "minitest", "~> 5.0"; Dir["test/test_*.rb"].map{|f| require f}' || die
}
