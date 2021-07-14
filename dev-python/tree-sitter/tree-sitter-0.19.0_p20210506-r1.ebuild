# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

EGIT_COMMIT="b4db17e4d43f27a040b4bf087695cc200512e4ea"
MY_P=py-tree-sitter-${EGIT_COMMIT}
FIXTURE_PV=0.19.0

DESCRIPTION="Python bindings to the Tree-sitter parsing library"
HOMEPAGE="https://github.com/tree-sitter/py-tree-sitter/"
SRC_URI="
	https://github.com/tree-sitter/py-tree-sitter/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
	test? (
		https://github.com/tree-sitter/tree-sitter-javascript/archive/v${FIXTURE_PV}.tar.gz
			-> tree-sitter-javascript-${FIXTURE_PV}.tar.gz
		https://github.com/tree-sitter/tree-sitter-python/archive/v${FIXTURE_PV}.tar.gz
			-> tree-sitter-python-${FIXTURE_PV}.tar.gz
	)"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="dev-libs/tree-sitter:="
DEPEND=${RDEPEND}

distutils_enable_tests setup.py

PATCHES=(
	"${FILESDIR}"/${P}-unbundle.patch
)

src_unpack() {
	default
	rmdir "${S}/tree_sitter/core" || die

	if use test; then
		mkdir "${S}/tests/fixtures" || die
		local f
		for f in tree-sitter-{javascript,python}; do
			mv "${f}-${FIXTURE_PV}" "${S}/tests/fixtures/${f}" || die
		done
	fi
}
