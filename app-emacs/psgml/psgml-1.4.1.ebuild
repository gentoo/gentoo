# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="A GNU Emacs Major Mode for editing SGML and XML coded documents"
HOMEPAGE="https://www.emacswiki.org/emacs/PsgmlMode"
# taken from https://marmalade-repo.org/packages/${P}.tar
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+ Texinfo-manual"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="app-text/openjade"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	${EMACS} ${EMACSFLAGS} --load psgml-maint.el -f psgml-compile-files || die
}

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	insinto "${SITEETC}/${PN}"
	doins *.map
	doinfo psgml.info psgml-api.info
	dodoc ChangeLog INSTALL README.psgml psgml.ps
}
