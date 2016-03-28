# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

# ruby22, ruby23: fails due to minitest incompatabilities.
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

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
	case ${RUBY} in
		*ruby22|*ruby23)
			einfo "Tests do not work with ${RUBY}"
			;;
		*)
			${RUBY} test/test_declarative_test.rb || die "Tests failed."
			;;
	esac
}
