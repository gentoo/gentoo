# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/test_declarative/test_declarative-0.0.5-r2.ebuild,v 1.6 2015/04/28 19:05:48 graaff Exp $

EAPI=5

# ruby22: fails due to minitest incompatabilities.
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit ruby-fakegem

DESCRIPTION="Simply adds a declarative test method syntax to test/unit"
HOMEPAGE="https://github.com/svenfuchs/test_declarative"
SRC_URI="https://github.com/svenfuchs/test_declarative/tarball/v${PV} -> ${P}.tgz"
RUBY_S="svenfuchs-test_declarative-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

each_ruby_test() {
	${RUBY} test/test_declarative_test.rb || die "Tests failed."
}
