# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/vdrsymbols-ttf/vdrsymbols-ttf-20100612.ebuild,v 1.4 2011/10/22 16:07:43 hd_brummy Exp $

S=${WORKDIR}/vdrsymbols

inherit font

DESCRIPTION="Font that contains symbols needed for VDR"

HOMEPAGE="http://andreas.vdr-developer.org/fonts/"
SRC_URI="http://andreas.vdr-developer.org/fonts/download/${P}.tgz"

LICENSE="BitstreamVera"

SLOT="0"
KEYWORDS="~arm amd64 x86"
IUSE=""
DEPEND=""
RDEPEND=""

FONT_SUFFIX="ttf"

pkg_postinst() {
	font_pkg_postinst

	elog "To get nice symbols in VDR's OSD"
	elog "you need to select the font VDRSymbolsSans."
}
