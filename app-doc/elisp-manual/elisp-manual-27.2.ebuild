# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The GNU Emacs Lisp Reference Manual"
HOMEPAGE="https://www.gnu.org/software/emacs/manual/"
# taken from doc/lispref/ (and some files from doc/emacs/) of emacs-${PV}
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"
S="${WORKDIR}/lispref"

LICENSE="FDL-1.3+"
SLOT="27"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"

BDEPEND="sys-apps/texinfo"

PATCHES=("${FILESDIR}/${P}-direntry.patch")

src_compile() {
	makeinfo -I "${WORKDIR}"/emacs elisp.texi || die
}

src_install() {
	doinfo elisp${SLOT}.info*
	dodoc README
}
