# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="https://pygraphviz.github.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 x86 ~x86-linux ~ppc-macos ~x64-macos"

# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
RDEPEND="media-gfx/graphviz"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	dev-lang/swig:0
	test? ( dev-python/doctest-ignore-unicode[${PYTHON_USEDEP}] )"

distutils_enable_tests nose

PATCHES=( "${FILESDIR}"/${PN}-1.5-docs.patch )

python_prepare_all() {
	distutils-r1_python_prepare_all
	swig -python pygraphviz/graphviz.i || die
}

python_test() {
	nosetests -c setup.cfg -x -v "${BUILD_DIR}"/lib/pygraphviz || die
}

python_install_all() {
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples

	distutils-r1_python_install_all
}
