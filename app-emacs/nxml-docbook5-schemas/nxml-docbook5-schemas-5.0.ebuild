# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Add support for DocBook 5 schemas to NXML"
HOMEPAGE="https://docbook.org/schemas/5x.html"
SRC_URI="https://docbook.org/xml/${PV}/rng/docbookxi.rnc -> docbookxi-${PV}.rnc"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}"
SITEFILE="60${PN}-gentoo.el"

src_unpack() { :; }

src_compile() { :; }

src_install() {
	insinto ${SITEETC}/${PN}
	doins "${FILESDIR}"/schemas.xml
	newins "${DISTDIR}"/docbookxi-${PV}.rnc docbookxi.rnc
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
