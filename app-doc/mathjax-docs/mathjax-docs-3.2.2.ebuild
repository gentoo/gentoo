# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
inherit python-any-r1 vcs-clean

# MathJax-docs doesn't have releases, so this is the commit that was
# current when mathjax-${PV} was released.
COMMIT="c4a733d6d0ced4242a4df1c46137d4be6b3aaaee"

DESCRIPTION="MathJax documentation"
HOMEPAGE="https://docs.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax-docs/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/MathJax-docs-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"

BDEPEND="
	$(python_gen_any_dep '
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
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
