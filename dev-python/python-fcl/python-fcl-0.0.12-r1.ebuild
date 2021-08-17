# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

DESCRIPTION="Python bindings for the Flexible Collision Library"
HOMEPAGE="https://github.com/BerkeleyAutomation/python-fcl https://pypi.org/project/python-fcl/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
LICENSE="BSD"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	~sci-libs/fcl-0.5.0
	sci-libs/octomap
"

PATCHES=( "${FILESDIR}"/${P}-fix-compiling-on-lld.patch )

distutils_enable_tests unittest

python_test() {
	"${EPYTHON}" test/test_fcl.py -v || die "tests failed with ${EPYTHON}"
}
