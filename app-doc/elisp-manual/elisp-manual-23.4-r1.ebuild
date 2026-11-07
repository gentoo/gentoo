# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="https://www.gnu.org/software/emacs/manual/"
# taken from doc/lispref/ of emacs-${PV}
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.tar.xz
	https://distfiles.gentoo.org/pub/proj/emacs/${P}-patches-1.tar.xz"
S="${WORKDIR}/lispref"

LICENSE="FDL-1.3+"
SLOT="23"
KEYWORDS="amd64 ppc x86"

BDEPEND="sys-apps/texinfo"

PATCHES=("${WORKDIR}/patch")

src_compile() {
	makeinfo --no-split elisp.texi || die
}

src_install() {
	doinfo elisp${SLOT}.info
	dodoc ChangeLog README
}
