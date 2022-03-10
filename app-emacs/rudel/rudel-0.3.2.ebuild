# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=24

inherit elisp readme.gentoo-r1

DESCRIPTION="Collaborative editing environment for GNU Emacs"
HOMEPAGE="http://rudel.sourceforge.net/
	https://www.emacswiki.org/emacs/Rudel"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz" # from GNU ELPA

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="60${PN}-gentoo-0.3.1.el"

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto "${SITEETC}/${PN}"
	doins -r icons

	dodoc README INSTALL ChangeLog TODO doc/card.pdf

	DOC_CONTENTS="Connections to Gobby servers require the gnutls-cli program
		(net-libs/gnutls[tools]).
		\\n\\nThe Avahi daemon (net-dns/avahi) is required for automatic
		session discovery and advertising."
	readme.gentoo_create_doc
}
