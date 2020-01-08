# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Simple VTXXX-compatible terminal emulator"
HOMEPAGE="https://pypi.org/project/pyte/ https://github.com/selectel/pyte"
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
# use github tarball as pypi is missing test data
SRC_URI="https://github.com/selectel/pyte/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/wcwidth[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	# run pytest directly for tests
	sed -i '/setup_requires=\["pytest-runner"\]/d' setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die "tests failed with ${EPYTHON}"
}
