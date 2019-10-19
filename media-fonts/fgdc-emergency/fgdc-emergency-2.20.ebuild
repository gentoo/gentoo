# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="FGDC Emergency Response Symbology Prototype"
HOMEPAGE="http://www.fgdc.gov/HSWG/"
SRC_URI="http://www.fgdc.gov/HSWG/symbol_downloads/ers_v${PV//./}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/ersSymbolsVersion0202"
FONT_S="${S}"
FONT_SUFFIX="ttf"

DOCS=( readme.txt )

src_install(){
	cp ersV2{sym,txt}/*.ttf . || die
	font_src_install
}
