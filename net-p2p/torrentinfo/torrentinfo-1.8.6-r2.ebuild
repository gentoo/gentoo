# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
# The package uses distutils
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="A torrent file parser"
HOMEPAGE="https://github.com/Fuuzetsu/torrentinfo"
SRC_URI="https://github.com/Fuuzetsu/torrentinfo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}/${P}-fix-tests.patch" )

python_test() {
	nosetests test/tests.py || die "tests failed with ${EPYTHON}"
}
