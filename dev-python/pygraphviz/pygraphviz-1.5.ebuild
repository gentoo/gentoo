# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="http://pygraphviz.github.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples test"
RESTRICT="!test? ( test )"

# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
RDEPEND="media-gfx/graphviz"
DEPEND="${RDEPEND}
	dev-lang/swig:0
	test? (
		dev-python/doctest-ignore-unicode[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-docs.patch
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	swig -python pygraphviz/graphviz.i || die
}

python_test() {
	PYTHONPATH=${PYTHONPATH}:${BUILD_DIR}/lib/pygraphviz \
		nosetests -c setup.cfg -x -v || die
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
