# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/lookup/lookup-1.4.1.ebuild,v 1.5 2014/08/29 06:48:10 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="An interface to search CD-ROM books and network dictionaries"
HOMEPAGE="http://openlab.jp/edict/lookup/"
SRC_URI="http://openlab.jp/edict/lookup/dist/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

ELISP_PATCHES="${P}-garbage-char.patch"
SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf --with-lispdir="${EPREFIX}${SITELISP}/${PN}"
}

src_compile() {
	# parallel make fails with Emacs deadlock
	emake -j1
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc AUTHORS ChangeLog NEWS README
}
