# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="https://pygraphviz.github.io/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~riscv x86 ~x86-linux ~ppc-macos ~x64-macos"

# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
RDEPEND="media-gfx/graphviz"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	dev-lang/swig:0
	test? ( dev-python/doctest-ignore-unicode[${PYTHON_USEDEP}] )"

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
