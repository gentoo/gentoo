# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

MY_PN=pyPEG2
MY_P=${MY_PN}-${PV}

DESCRIPTION="An intrinsic PEG Parser-Interpreter for Python"
HOMEPAGE="https://fdik.org/pyPEG/
	https://bitbucket.org/fdik/pypeg/
	https://pypi.org/project/pyPEG2/"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2.15.1-test.patch )

python_test() {
	"${PYTHON}" -m unittest discover || die "Tests failed with ${EPYTHON}"
}
