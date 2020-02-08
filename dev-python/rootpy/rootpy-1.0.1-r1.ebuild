# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
PYTHON_REQ_USE="readline"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Pythonic layer on top of the ROOT framework's PyROOT bindings"
HOMEPAGE="http://rootpy.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

RDEPEND="
	sci-physics/root:=[${PYTHON_SINGLE_USEDEP}]
	dev-python/root_numpy[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/matplotlib[${PYTHON_MULTI_USEDEP}]
		dev-python/pytables[${PYTHON_MULTI_USEDEP}]
		dev-python/termcolor[${PYTHON_MULTI_USEDEP}]
	')"

DEPEND="
	sci-physics/root[${PYTHON_SINGLE_USEDEP}]
	test? (
		$(python_gen_cond_dep '
			dev-python/nose[${PYTHON_MULTI_USEDEP}]
		')
	)"

# TOFIX: tests go in an infinite loop error
RESTRICT=test

python_test() {
	cd "${BUILD_DIR}" || die
	nosetests -v || die "Testing failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
