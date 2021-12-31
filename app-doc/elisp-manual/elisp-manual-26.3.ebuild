# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="https://www.gnu.org/software/emacs/manual/"
# taken from doc/lispref/ (and some files from doc/emacs/) of emacs-${PV}
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="FDL-1.3+"
SLOT="26"
KEYWORDS="amd64 ppc x86"

DEPEND="sys-apps/texinfo"

S="${WORKDIR}/lispref"
PATCHES=("${FILESDIR}/${P}-direntry.patch")

src_compile() {
	makeinfo -I "${WORKDIR}"/emacs elisp.texi || die
}

src_install() {
	doinfo elisp${SLOT}.info*
	dodoc README
}
