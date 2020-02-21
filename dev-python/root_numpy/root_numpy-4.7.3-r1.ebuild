# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="Interface between ROOT and numpy"
HOMEPAGE="https://github.com/rootpy/root_numpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_MULTI_USEDEP}]
	')
	sci-physics/root:=[python,${PYTHON_SINGLE_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/nose[${PYTHON_MULTI_USEDEP}] )
		')"

python_test() {
	cd "${BUILD_DIR}" || die
	nosetests -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	use examples && local EXAMPLES=( tutorial/. )
	distutils-r1_python_install_all
}
