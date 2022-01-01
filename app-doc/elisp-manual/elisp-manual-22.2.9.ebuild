# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit epatch

MY_P=${PN}-${PV/./-}
DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="https://www.gnu.org/software/emacs/manual/"
# Taken from lispref/ of emacs-22.3
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${MY_P}.tar.bz2"

LICENSE="FDL-1.2+"
SLOT="22"
KEYWORDS="amd64 ppc x86"

DEPEND="sys-apps/texinfo"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-direntry.patch"
}

src_compile() {
	makeinfo elisp.texi || die
}

src_install() {
	doinfo elisp22.info*
	dodoc ChangeLog README
}
