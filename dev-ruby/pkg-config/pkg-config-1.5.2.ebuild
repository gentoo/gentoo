# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="README.rdoc NEWS"

inherit ruby-fakegem

DESCRIPTION="A pkg-config implementation by Ruby"
HOMEPAGE="https://github.com/ruby-gnome/pkg-config"
LICENSE="|| ( LGPL-2 LGPL-2.1 LGPL-3 )"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ppc ppc64 ~riscv ~s390 sparc x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 )"
# this is used for testing
DEPEND+=" test? ( x11-libs/cairo )"

all_ruby_prepare() {
	sed -e '/test_cflags/aomit "Fragile on Gentoo"' -i test/test-pkg-config.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test-pkg-config.rb || die
}
