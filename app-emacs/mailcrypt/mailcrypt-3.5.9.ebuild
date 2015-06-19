# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mailcrypt/mailcrypt-3.5.9.ebuild,v 1.7 2014/08/29 06:55:28 ulm Exp $

EAPI=5

inherit readme.gentoo elisp autotools

DESCRIPTION="Provides a simple interface to public key cryptography with OpenPGP"
HOMEPAGE="http://mailcrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/mailcrypt/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
RESTRICT="test"

RDEPEND="app-crypt/gnupg"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	eautoreconf
}

src_configure() {
	export EMACS=/usr/bin/emacs
	econf
}

src_install() {
	emake \
		lispdir="${D}${SITELISP}/${PN}" \
		infodir="${D}/usr/share/info" \
		install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ANNOUNCE ChangeLog* INSTALL LCD-entry NEWS ONEWS README*

	DOC_CONTENTS="See the INSTALL file in /usr/share/doc/${PF} for how
		to customize mailcrypt."
	readme.gentoo_create_doc
}
