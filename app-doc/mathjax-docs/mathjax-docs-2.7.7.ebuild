# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit python-any-r1 python-utils-r1 vcs-clean

COMMIT="9d711f40638202b02f2154d7f05ea35088ff9388"

DESCRIPTION="MathJax documentation"
HOMEPAGE="https://www.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax-docs/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/MathJax-docs-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	')
"

DOCS=(
	README.md
)

src_prepare() {
	default
	egit_clean
}

src_compile() {
	build_sphinx "${S}"
}
