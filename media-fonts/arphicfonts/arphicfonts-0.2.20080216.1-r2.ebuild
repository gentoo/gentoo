# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit font eutils

DESCRIPTION="Chinese TrueType Arphic Fonts"
HOMEPAGE="http://www.arphic.com.tw/
	https://www.freedesktop.org/wiki/Software/CJKUnifonts"
SRC_URI="mirror://gnu/non-gnu/chinese-fonts-truetype/gkai00mp.ttf.gz
	mirror://gnu/non-gnu/chinese-fonts-truetype/bkai00mp.ttf.gz
	mirror://gnu/non-gnu/chinese-fonts-truetype/bsmi00lp.ttf.gz
	mirror://gnu/non-gnu/chinese-fonts-truetype/gbsn00lp.ttf.gz
	mirror://ubuntu/pool/main/t/ttf-arphic-uming/ttf-arphic-uming_${PV}.orig.tar.gz
	mirror://ubuntu/pool/main/t/ttf-arphic-ukai/ttf-arphic-ukai_${PV}.orig.tar.gz"

LICENSE="Arphic"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

DEPEND="media-gfx/fontforge"

S="${WORKDIR}"

#No binaries, only fonts
RESTRICT="strip binchecks"

FONT_S="${S}"
FONT_SUFFIX="ttc ttf"
FONT_CONF=(	"25-ttf-arphic-ukai-render.conf"
		"35-ttf-arphic-ukai-aliases.conf"
		"41-ttf-arphic-ukai.conf"
		"75-ttf-arphic-ukai-select.conf"
		"90-ttf-arphic-ukai-embolden.conf"
		"25-ttf-arphic-uming-bitmaps.conf"
		"25-ttf-arphic-uming-render.conf"
		"35-ttf-arphic-uming-aliases.conf"
		"41-ttf-arphic-uming.conf"
		"64-ttf-arphic-uming.conf"
		"90-ttf-arphic-uming-embolden.conf" )

src_unpack() {
	#All of this is to ensure that we don't overwrite one font's docs
	#with another's.

	unpack {gk,bk}ai00mp.ttf.gz {bsmi,gbsn}00lp.ttf.gz
	mkdir "${WORKDIR}"/{uming,ukai}

	cd "${WORKDIR}"/uming
	unpack ttf-arphic-uming_${PV}.orig.tar.gz

	cd "${WORKDIR}"/ukai
	unpack ttf-arphic-ukai_${PV}.orig.tar.gz
}

src_prepare() {
	cd "${WORKDIR}"
	find "${WORKDIR}" -mindepth 2 -maxdepth 2 -name '*.ttc' -exec mv {} . \;
	find "${WORKDIR}" -name '*.conf' -exec mv "{}" . \;
	epatch "${FILESDIR}"/${P}-fontconfig.patch
	fontforge -script "${FILESDIR}"/${P}.pe b*.ttf || die
}

src_install() {
	local myfont doc
	for myfont in ukai uming
	do
		cd "${WORKDIR}"/${myfont}
		docinto ${myfont}
		for doc in  FONTLOG KNOWN_ISSUES TODO README README.Bitmap NEWS CONTRIBUTERS
		do
			[ -f ${doc} ] && dodoc ${doc}
		done
	done
	cd "${S}"
	font_src_install
}
