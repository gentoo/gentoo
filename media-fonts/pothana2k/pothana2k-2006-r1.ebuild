# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/pothana2k/pothana2k-2006-r1.ebuild,v 1.6 2012/06/30 05:37:12 yngwin Exp $

inherit font

DESCRIPTION="Pothana 2000 and Vemana fonts for the Telugu script"
HOMEPAGE="http://www.kavya-nandanam.com/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="doc"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"
FONT_S="${WORKDIR}"
FONT_SUFFIX="ttf"

FONT_CONF=( "${FILESDIR}/65-pothana2k.conf" )

src_install() {
	font_src_install
	if use doc
	then
		dodoc MANUAL.PDF
	fi
}
