# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P1="Scheherazade-${PV}"
MY_P2="LateefGR-1.200"
inherit font

DESCRIPTION="SIL Opentype Unicode fonts for Arabic Languages"
HOMEPAGE="http://scripts.sil.org/ArabicFonts"
SRC_URI="https://software.sil.org/downloads/r/scheherazade/${MY_P1}.zip
	https://software.sil.org/downloads/r/lateef/${MY_P2}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 ~s390 ~sh ~sparc x86"

DEPEND="app-arch/unzip"
RDEPEND=""
IUSE=""

DOCS="FONTLOG.txt OFL-FAQ.txt"
FONT_SUFFIX="ttf"
FONT_S="${S}"

src_unpack() {
	default
	mv "${MY_P1}" "${P}" || die
	mv "${MY_P2}/LateefGR-Regular.ttf" "${P}" || die
}
