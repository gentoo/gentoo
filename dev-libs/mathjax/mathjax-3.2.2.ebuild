# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vcs-clean

DESCRIPTION="JavaScript display engine for LaTeX, MathML and AsciiMath"
HOMEPAGE="https://www.mathjax.org/"
SRC_URI="https://github.com/mathjax/MathJax/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/MathJax-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc"

RDEPEND="doc? ( ~app-doc/mathjax-docs-${PV} )"

src_prepare() {
	default
	egit_clean
}

src_install() {
	local DOCS=( CONTRIBUTING.md README.md )
	default

	if use doc; then
		# We need best_version to determine the right revision for
		# app-doc/mathjax-docs.
		local docsPF=$(best_version app-doc/mathjax-docs)

		# Strip the (known) category from the best_version output.
		docsPF=${docsPF#app-doc/}

		dosym "../${docsPF}/html" "/usr/share/doc/${PF}/html"
	fi

	insinto "/usr/share/${PN}"

	# Start the install beneath the "es5" directory for compatibility with
	# Arch, Solus, and Void Linux.
	doins -r es5/*
}
