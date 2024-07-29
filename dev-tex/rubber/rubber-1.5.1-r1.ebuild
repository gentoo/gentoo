# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A LaTeX wrapper for automatically building documents"
HOMEPAGE="https://launchpad.net/rubber/"
SRC_URI="https://launchpad.net/rubber/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="virtual/latex-base"
BDEPEND="${RDEPEND}
	virtual/texi2dvi"

pkg_setup() {
	# https://bugs.gentoo.org/727996
	export VARTEXFONTS="${T}"/fonts
}

python_install() {
	distutils-r1_python_install \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--infodir="${EPREFIX}"/usr/share/info \
		--mandir="${EPREFIX}"/usr/share/man
}
