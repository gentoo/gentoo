# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Font that contains symbols needed for VDR"
HOMEPAGE="http://andreas.vdr-developer.org/fonts/"
SRC_URI="http://andreas.vdr-developer.org/fonts/download/${P}.tgz"
S="${WORKDIR}/vdrsymbols"

LICENSE="BitstreamVera"
SLOT="0"
KEYWORDS="~amd64 ~arm ~loong ~x86"

FONT_S="${S}"
FONT_SUFFIX="ttf"

pkg_postinst() {
	font_pkg_postinst

	elog "To get nice symbols in VDR's OSD"
	elog "you need to select the font VDRSymbolsSans."
}
