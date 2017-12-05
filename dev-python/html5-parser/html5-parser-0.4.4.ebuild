# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Fast C based HTML 5 parsing for python"
HOMEPAGE="https://github.com/kovidgoyal/html5-parser/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2:=
	>=dev-python/lxml-3.8.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test || die "Tests failed under ${EPYTHON}"
}
