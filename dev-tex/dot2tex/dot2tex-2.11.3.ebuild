# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A Graphviz to LaTeX converter"
HOMEPAGE="https://dot2tex.readthedocs.org/ https://github.com/kjellmf/dot2tex"
SRC_URI="https://github.com/kjellmf/dot2tex/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~sparc-solaris"
IUSE="doc examples"

DEPEND="dev-python/pyparsing[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/pydot[${PYTHON_USEDEP}]
	media-gfx/graphviz"
DEPEND="${DEPEND}"
BDEPEND="doc? ( dev-python/sphinx )"

EPYTEST_DESELECT=(
	# https://github.com/kjellmf/dot2tex/issues/94
	tests/test_dot2tex.py::MultipleStatements::test_semicolon
)

distutils_enable_tests pytest

python_prepare_all() {
	# Syntax failures (old-style print)
	# Looks fixed in master: https://github.com/kjellmf/dot2tex/commit/38aeef9615f90fe347c5c45d514eaf00b116422b
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
