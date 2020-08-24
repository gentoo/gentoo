# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7} )

inherit distutils-r1

MY_PN=${PN/p/P}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Python-based software project scripting tool along the lines of Make"
HOMEPAGE="https://pythonhosted.org/Paver/ https://github.com/paver/paver"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 sparc x86 ~x64-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"

DEPEND="
	${RDEPEND}
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# https://github.com/paver/paver/issues/143#issuecomment-103943327
	find paver/tests -name '*.pyc' -delete || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
