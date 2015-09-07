# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="http://networkx.lanl.gov/pygraphviz/ https://pypi.python.org/pypi/pygraphviz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="examples test"

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
	"${FILESDIR}"/${P}-swig-3.patch
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
