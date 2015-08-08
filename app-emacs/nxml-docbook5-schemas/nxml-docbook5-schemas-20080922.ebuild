# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
