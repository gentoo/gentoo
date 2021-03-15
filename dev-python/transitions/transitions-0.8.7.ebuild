# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="A lightweight, object-oriented state machine implementation in Python"
HOMEPAGE="https://github.com/pytransitions/transitions"
SRC_URI="https://github.com/pytransitions/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="examples"

RDEPEND="
	|| (
		dev-python/pygraphviz[${PYTHON_USEDEP}]
		dev-python/graphviz[${PYTHON_USEDEP}]
	)
	dev-python/six[${PYTHON_USEDEP}]
"

DEPEND="
	test? (
		dev-python/dill[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pycodestyle[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install

	use examples && dodoc examples/*.ipynb
}
