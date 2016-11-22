# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Line-by-line profiler"
HOMEPAGE="https://github.com/rkern/line_profiler"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
	"

PATCHES=(
	"${FILESDIR}/${P}-fix-name-from-copypasta.patch"
	"${FILESDIR}/${P}-ipython-5.0-compatibility.patch"
)

python_test() {
	"${PYTHON}" -m unittest discover -v "${S}"/tests/ \
		|| die "Tests failed with ${EPYTHON}"
}
