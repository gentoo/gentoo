# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="https://www.gnu.org/software/emacs/manual/"
# taken from doc/lispref/ (and some files from doc/emacs/) of emacs-${PV}
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.tar.xz
	https://distfiles.gentoo.org/pub/proj/emacs/${P}-patches-1.tar.xz"
S="${WORKDIR}/lispref"

LICENSE="FDL-1.3+"
SLOT="${PV%%.*}"
KEYWORDS="amd64 ppc ~riscv x86"

BDEPEND="sys-apps/texinfo"

PATCHES=("${WORKDIR}/patch")

src_compile() {
	makeinfo --no-split -I "${WORKDIR}"/emacs elisp.texi || die
}

src_install() {
	doinfo elisp${SLOT}.info
	dodoc README
}
