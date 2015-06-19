# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cliapp/cliapp-1.20150305.ebuild,v 1.2 2015/04/08 08:05:02 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Framework for Unix-like command line programs"
HOMEPAGE="http://liw.fi/cliapp/"
SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/cliapp/snapshot/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

DEPEND="${PYTHON_DEPS}
	test? ( dev-python/CoverageTestRunner )"

src_test() {
	use test && addwrite /proc/self/comm
	distutils-r1_src_test
}

python_test() {
	emake check
}
