# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} pypy3 )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="A flexible Python Kconfig implementation"
HOMEPAGE="https://github.com/ulfalizer/Kconfiglib https://pypi.org/project/kconfiglib/"
SRC_URI="https://github.com/ulfalizer/Kconfiglib/archive/v${PV}.tar.gz -> ${P}.tar.gz"
# pypi tarballs don't include tests
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/k/K}

PATCHES=( "${FILESDIR}"/${P}-setup.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all

	# hacks to run tests
	mkdir Kconfiglib || die
	ln -s ../tests Kconfiglib || die
	# don't run kernel Kconfig compat tests
	sed -i 's/run_compatibility_tests()$/#\0/' testsuite.py || die
}

python_test() {
	"${PYTHON}" testsuite.py || die "tests failed with ${EPYTHON}"
}
