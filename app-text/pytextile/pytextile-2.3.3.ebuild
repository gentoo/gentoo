# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

MY_PN="python-textile"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python port of Textile, A humane web text generator"
HOMEPAGE="https://github.com/textile/python-textile"
SRC_URI="https://github.com/textile/python-textile/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pytest-runner[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/regex[${PYTHON_USEDEP}]
	"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# This resolves a nasty race condition, courtesy of Arfrever
	sed -e 's:with-id = 1::' -i setup.cfg || die
	# remove useless --cov arg injection
	rm pytest.ini || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test || die "Testsuite failed under ${EPYTHON}"
}
