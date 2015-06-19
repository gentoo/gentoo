# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/prettytable/prettytable-0.7.2.ebuild,v 1.1 2015/05/26 10:13:44 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Easily displaying tabular data in a visually appealing ASCII table format"
HOMEPAGE="https://code.google.com/p/prettytable/"
SRC_URI="mirror://pypi/P/PrettyTable/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	"${PYTHON}" prettytable_test.py || die "tests failed under ${EPYTHON}"
}
