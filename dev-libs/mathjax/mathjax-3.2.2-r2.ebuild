# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} pypy3 )
inherit python-any-r1

# MathJax-docs doesn't have releases, so this is the commit that was
# current when mathjax-${PV} was released.
DOCS_COMMIT="c4a733d6d0ced4242a4df1c46137d4be6b3aaaee"

DESCRIPTION="JavaScript display engine for LaTeX, MathML and AsciiMath"
HOMEPAGE="https://www.mathjax.org/"
SRC_URI="
	https://github.com/mathjax/MathJax/archive/${PV}.tar.gz -> ${P}.tar.gz
	doc? ( https://github.com/mathjax/MathJax-docs/archive/${DOCS_COMMIT}.tar.gz -> ${PN}-docs-${PV}.tar.gz )
"
S="${WORKDIR}/MathJax-${PV}"
DOCS_S="${WORKDIR}/MathJax-docs-${DOCS_COMMIT}"

LICENSE="Apache-2.0"
# Some applications need to know which mathjax version they built against.
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

BDEPEND="
	doc? (
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]
		')
	)
"
RDEPEND="!app-doc/mathjax-docs"

python_check_deps() {
	python_has_version "dev-python/sphinx[${PYTHON_USEDEP}]" &&
	python_has_version "dev-python/sphinx-rtd-theme[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if use doc; then
		python-any-r1_pkg_setup
	fi
}

src_compile() {
	if use doc; then
		build_sphinx "${DOCS_S}"
	fi
}

src_install() {
	local DOCS=( CONTRIBUTING.md README.md )
	default

	insinto "/usr/share/${PN}"

	# Start the install beneath the "es5" directory for compatibility with
	# Arch, Solus, and Void Linux, but leave a fake "es5" symlink for
	# packages (like doxygen) that expect it.
	doins -r es5/*
	dosym -r "/usr/share/${PN}" "/usr/share/${PN}/es5"
}
