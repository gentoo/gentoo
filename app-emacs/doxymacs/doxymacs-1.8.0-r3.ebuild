# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/doxymacs/doxymacs-1.8.0-r3.ebuild,v 1.5 2014/06/07 11:08:58 ulm Exp $

EAPI=5

inherit elisp flag-o-matic

DESCRIPTION="Doxygen editing minor mode"
HOMEPAGE="http://doxymacs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=">=dev-libs/libxml2-2.6.13"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	append-flags -Wno-error		#260874
	econf --with-lispdir="${SITELISP}/${PN}"
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc AUTHORS ChangeLog NEWS README TODO
}
