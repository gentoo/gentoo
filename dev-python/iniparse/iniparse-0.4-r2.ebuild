# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Better INI parser for Python"
HOMEPAGE="https://pypi.python.org/pypi/iniparse"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT PSF-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-python/six-1.10.0[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-python3.patch"
	"${FILESDIR}/${P}-tests.patch"
)

python_test() {
	"${EPYTHON}" runtests.py || die
}
