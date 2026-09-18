# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

COMMIT=2e556e540dd4ccce0e24c92d4413ef9ac85284a5

inherit distutils-r1

DESCRIPTION="Python bindings to the Tree-sitter parsing library"
HOMEPAGE="
	https://github.com/tree-sitter/py-tree-sitter/
	https://pypi.org/project/tree-sitter/
"
SRC_URI="
	https://github.com/tree-sitter/py-tree-sitter/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/py-${PN}-${COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

# setuptools is needed for distutils import
DEPEND="
	>=dev-libs/tree-sitter-0.26:=
	<dev-libs/tree-sitter-0.28
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		>=dev-libs/tree-sitter-html-0.23.2[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-javascript-0.23.1[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-json-0.24.8[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-python-0.23.6[python,${PYTHON_USEDEP}]
		>=dev-libs/tree-sitter-rust-0.23.2[python,${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${PN}-0.22.2-unbundle.patch
)

src_unpack() {
	default
	rmdir "${S}/tree_sitter/core" || die
}

src_test() {
	rm -r tree_sitter || die
	distutils-r1_src_test
}
