# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy3 python3_{7..10} )
# The package uses distutils
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="A torrent file parser"
HOMEPAGE="https://github.com/Fuuzetsu/torrentinfo"
SRC_URI="https://github.com/Fuuzetsu/torrentinfo/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

PATCHES=( "${FILESDIR}/${P}-fix-tests.patch" )

distutils_enable_tests nose

# distutils_enable_tests nose doesn't work here,
# probably because the test file has a non-standard name
python_test() {
	nosetests test/tests.py || die "tests failed with ${EPYTHON}"
}
