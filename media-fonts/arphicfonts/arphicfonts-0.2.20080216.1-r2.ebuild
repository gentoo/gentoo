# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font xdg-utils

DESCRIPTION="Chinese TrueType Arphic Fonts"
HOMEPAGE="http://www.arphic.com.tw/
	https://www.freedesktop.org/wiki/Software/CJKUnifonts"
SRC_URI="mirror://gnu/non-gnu/chinese-fonts-truetype/gkai00mp.ttf.gz
	mirror://gnu/non-gnu/chinese-fonts-truetype/bkai00mp.ttf.gz
	mirror://gnu/non-gnu/chinese-fonts-truetype/bsmi00lp.ttf.gz
	mirror://gnu/non-gnu/chinese-fonts-truetype/gbsn00lp.ttf.gz
	mirror://ubuntu/pool/main/t/ttf-arphic-uming/ttf-arphic-uming_${PV}.orig.tar.gz
	mirror://ubuntu/pool/main/t/ttf-arphic-ukai/ttf-arphic-ukai_${PV}.orig.tar.gz"
S="${WORKDIR}"

LICENSE="Arphic"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

# No binaries, only fonts
RESTRICT="strip binchecks"

BDEPEND="media-gfx/fontforge"

PATCHES=( "${FILESDIR}"/${P}-fontconfig.patch )

FONT_CONF=(
	ukai/25-ttf-arphic-ukai-render.conf
	ukai/35-ttf-arphic-ukai-aliases.conf
	ukai/41-ttf-arphic-ukai.conf
	ukai/75-ttf-arphic-ukai-select.conf
	ukai/90-ttf-arphic-ukai-embolden.conf
	uming/25-ttf-arphic-uming-bitmaps.conf
	uming/25-ttf-arphic-uming-render.conf
	uming/35-ttf-arphic-uming-aliases.conf
	uming/41-ttf-arphic-uming.conf
	uming/64-ttf-arphic-uming.conf
	uming/90-ttf-arphic-uming-embolden.conf
)
FONT_SUFFIX="ttc ttf"

# ensure that we don't overwrite one font's docs with another's
src_unpack() {
	unpack {gk,bk}ai00mp.ttf.gz {bsmi,gbsn}00lp.ttf.gz

	do_unpack() {
		mkdir ${1} || die
		pushd ${1} > /dev/null || die
			unpack ttf-arphic-${1}_${PV}.orig.tar.gz
		popd > /dev/null || die
		mv ${1}/${1}.ttc . || die
	}
	do_unpack ukai
	do_unpack uming
}

src_prepare() {
	default
	xdg_environment_reset
	fontforge -script "${FILESDIR}"/${P}.pe b*.ttf || die
}

src_install() {
	font_src_install

	do_doc() {
		for doc in FONTLOG KNOWN_ISSUES TODO README README.Bitmap NEWS CONTRIBUTERS
		do
			[[ -f ${1}/${doc} ]] && newdoc ${1}/${doc} ${1}.${doc}
		done
	}
	do_doc ukai
	do_doc uming
}
