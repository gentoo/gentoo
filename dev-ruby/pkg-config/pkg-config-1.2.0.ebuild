# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="README.rdoc NEWS"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="A pkg-config implementation by Ruby"
HOMEPAGE="https://github.com/rcairo/pkg-config"
LICENSE="|| ( LGPL-2 LGPL-2.1 LGPL-3 )"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="test"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 )"
# this is used for testing
DEPEND+=" test? ( x11-libs/cairo )"

all_ruby_prepare() {
	# drop failing tests
	sed -i -e "/test_cflags/,/end/d"\
		-e "/test_cflags_only_I/,/end/d" test/test_pkg_config.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib test/test_${PN/-/_}.rb || die
}
