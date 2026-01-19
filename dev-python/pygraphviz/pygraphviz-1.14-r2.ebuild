# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python wrapper for the Graphviz Agraph data structure"
HOMEPAGE="
	https://pygraphviz.github.io/
	https://github.com/pygraphviz/pygraphviz/
	https://pypi.org/project/pygraphviz/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc64 ~riscv x86 ~x64-macos"

# Note: only C API of graphviz is used, PYTHON_USEDEP unnecessary.
DEPEND="
	media-gfx/graphviz:=
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	dev-lang/swig:0
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	# https://github.com/pygraphviz/pygraphviz/pull/573
	# (includes some setup.py changes from main due to rebase)
	"${FILESDIR}"/pygraphviz-1.14-graphviz-14.patch
)

python_test() {
	rm -rf pygraphviz || die
	epytest --pyargs pygraphviz
}

python_install_all() {
	dodoc -r examples
	docompress -x /usr/share/doc/${PF}/examples

	distutils-r1_python_install_all
}
