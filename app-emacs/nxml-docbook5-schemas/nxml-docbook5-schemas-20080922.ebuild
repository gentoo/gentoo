# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/nxml-docbook5-schemas/nxml-docbook5-schemas-20080922.ebuild,v 1.6 2014/06/07 11:23:42 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="Add support for DocBook 5 schemas to NXML"
HOMEPAGE="http://www.docbook.org/schemas/5x.html"
SRC_URI="http://www.docbook.org/xml/5.0/rng/docbookxi.rnc"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}"
SITEFILE="60${PN}-gentoo.el"

src_unpack() { :; }

src_compile() { :; }

src_install() {
	insinto ${SITEETC}/${PN}
	doins "${FILESDIR}"/schemas.xml "${DISTDIR}"/docbookxi.rnc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
