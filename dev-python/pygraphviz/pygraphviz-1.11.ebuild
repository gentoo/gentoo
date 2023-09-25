# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="
	https://pygraphviz.github.io/
	https://github.com/pygraphviz/pygraphviz/
	https://pypi.org/project/pygraphviz/
"
SRC_URI="$(pypi_sdist_url "${PN}" "${PV}" .zip)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86 ~x86-linux ~ppc-macos ~x64-macos"

# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
DEPEND="
	media-gfx/graphviz
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	app-arch/unzip
	dev-lang/swig:0
"

distutils_enable_tests pytest

src_configure() {
	swig -python pygraphviz/graphviz.i || die
}

python_test() {
	cd "${BUILD_DIR}"/install || die
	epytest
}

python_install_all() {
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples

	distutils-r1_python_install_all
}
