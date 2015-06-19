# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/blessings/blessings-1.6.ebuild,v 1.2 2015/02/19 08:07:55 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="A thin, practical wrapper around terminal coloring, styling, and positioning"
HOMEPAGE="https://github.com/erikrose/blessings https://pypi.python.org/pypi/blessings/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="dev-python/nose[${PYTHON_USEDEP}]"
RDEPEND=""

python_test() {
	nosetests --verbosity=3 ${PN} || die
}
