# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Graphviz to LaTeX converter"
HOMEPAGE="https://dot2tex.readthedocs.org/ https://github.com/xyz2tex/dot2tex"
SRC_URI="https://github.com/xyz2tex/dot2tex/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"
IUSE="doc examples"

DEPEND="dev-python/pyparsing[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/pydot[${PYTHON_USEDEP}]
	media-gfx/graphviz
"
BDEPEND="doc? ( dev-python/sphinx )"

EPYTEST_DESELECT=(
	# https://github.com/xyz2tex/dot2tex/issues/94
	tests/test_dot2tex.py::MultipleStatements::test_semicolon
)

PATCHES=(
	"${FILESDIR}"/${P}-setup-py-script.patch
)

distutils_enable_tests pytest

python_prepare_all() {
	# Syntax failures (old-style print)
	# Looks fixed in master: https://github.com/xyz2tex/dot2tex/commit/38aeef9615f90fe347c5c45d514eaf00b116422b
	rm -r "${S}"/tests/experimental || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc ; then
		cd "${S}/docs"
		emake html
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		dodoc -r docs/_build/html
	fi
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
