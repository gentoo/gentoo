# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}-${PV/./-}
DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="https://www.gnu.org/software/emacs/manual/"
# Taken from lispref/ of emacs-22.3
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="FDL-1.2+"
SLOT="22"
KEYWORDS="amd64 ppc x86"

BDEPEND="sys-apps/texinfo"

PATCHES=("${FILESDIR}/${P}-direntry.patch")

src_compile() {
	makeinfo --no-split elisp.texi || die
}

src_install() {
	doinfo elisp${SLOT}.info
	dodoc ChangeLog README
}
