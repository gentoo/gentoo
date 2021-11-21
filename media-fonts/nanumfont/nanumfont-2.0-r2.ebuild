# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

MY_PN="NanumGothicCoding"

DESCRIPTION="Korean monospace font distributed by Naver"
HOMEPAGE="https://github.com/naver/nanumfont"
SRC_URI="https://github.com/naver/${PN}/releases/download/VER${PV}/${MY_PN}-${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"
S="${WORKDIR}"

FONT_SUFFIX="ttf"

src_unpack() {
	if has_version -b "app-arch/unzip[natspec]"; then
		unzip -qO CP949 "${DISTDIR}"/${A} || die
	else
		default
	fi
	# Rename names in cp949 encoding, bug #322041
	mv *-Bold.ttf "${T}"/${MY_PN}-Bold.ttf || die
	mv *.ttf      "${T}"/${MY_PN}.ttf      || die
	mv "${T}"/*.ttf . || die
}
