# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

MY_PN="python-fcl"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for the Flexible Collision Library"
HOMEPAGE="https://github.com/BerkeleyAutomation/python-fcl https://pypi.org/project/python-fcl/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
LICENSE="BSD"

KEYWORDS="~amd64"
SLOT="0"
IUSE="examples"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	~sci-libs/fcl-0.5.0
	sci-libs/octomap
"

S=${WORKDIR}/${MY_P}

distutils_enable_tests unittest

python_install_all() {
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r example
	fi

	distutils-r1_python_install_all
}

python_test() {
	"${EPYTHON}" test/test_fcl.py -v || die "tests failed with ${EPYTHON}"
}
