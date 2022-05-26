# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

EGIT_COMMIT="4f39f6919ca3be8efb420a338fd2cf9b8b68b156"
MY_P=py-tree-sitter-${EGIT_COMMIT}
FIXTURE_PV=0.19.0

DESCRIPTION="Python bindings to the Tree-sitter parsing library"
HOMEPAGE="
	https://github.com/tree-sitter/py-tree-sitter/
	https://pypi.org/project/tree-sitter/
"
SRC_URI="
	https://github.com/tree-sitter/py-tree-sitter/archive/${EGIT_COMMIT}.tar.gz
		-> ${MY_P}.tar.gz
	test? (
		https://github.com/tree-sitter/tree-sitter-javascript/archive/v${FIXTURE_PV}.tar.gz
			-> tree-sitter-javascript-${FIXTURE_PV}.tar.gz
		https://github.com/tree-sitter/tree-sitter-python/archive/v${FIXTURE_PV}.tar.gz
			-> tree-sitter-python-${FIXTURE_PV}.tar.gz
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-libs/tree-sitter:=
"
DEPEND="
	${RDEPEND}
"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}"/tree-sitter-0.19.0_p20210506-unbundle.patch
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

src_test() {
	rm -r tree_sitter || die
	distutils-r1_src_test
}
