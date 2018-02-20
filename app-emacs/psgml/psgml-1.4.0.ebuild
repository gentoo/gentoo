# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="A GNU Emacs Major Mode for editing SGML and XML coded documents"
HOMEPAGE="https://sourceforge.net/projects/psgml/
	https://www.emacswiki.org/emacs/PsgmlMode"
SRC_URI="http://www.fsavigny.de/gpled-software/${P}.tar.gz"

LICENSE="GPL-2+ Texinfo-manual"
SLOT="0"
KEYWORDS="amd64 ppc x86"

DEPEND="app-text/openjade"
RDEPEND="${DEPEND}"

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
