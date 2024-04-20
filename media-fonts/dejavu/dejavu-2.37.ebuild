# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font xdg-utils

DESCRIPTION="DejaVu fonts, bitstream vera with ISO-8859-2 characters"
HOMEPAGE="https://dejavu-fonts.github.io/"

# If you want to test snapshot from dejavu.sf.net/snapshots/
# just rename ebuild to dejavu-2.22.20071220.2156.ebuild
MY_PV=$(ver_cut 1-2)
snapv=$(ver_cut 3-4)
snapv=${snapv/./-}
MY_BP=${PN}-fonts-ttf-${MY_PV}
MY_SP=${PN}-fonts-${MY_PV}

if [[ -z ${snapv} ]]; then
	SRC_URI="!fontforge? ( mirror://sourceforge/${PN}/${MY_BP}.tar.bz2 )
		fontforge? ( mirror://sourceforge/${PN}/${MY_SP}.tar.bz2 )"
else
	SRC_URI="!fontforge? ( http://dejavu.sourceforge.net/snapshots/${MY_BP}-${snapv}.tar.bz2 )
		fontforge? ( http://dejavu.sourceforge.net/snapshots/${MY_SP}-${snapv}.tar.bz2 )"
fi

LICENSE="BitstreamVera"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="fontforge"

BDEPEND="
	fontforge? (
		app-i18n/unicode-data
		dev-perl/Font-TTF
		>=media-gfx/fontforge-20080429
		>media-libs/fontconfig-2.6.0:1.0
		>=x11-apps/mkfontscale-1.2.0
	)
"

DOCS=( AUTHORS NEWS README.md status.txt langcover.txt unicover.txt )

FONT_CONF=(
	fontconfig/20-unhint-small-dejavu-sans-mono.conf
	fontconfig/20-unhint-small-dejavu-sans.conf
	fontconfig/20-unhint-small-dejavu-serif.conf
	fontconfig/57-dejavu-sans-mono.conf
	fontconfig/57-dejavu-sans.conf
	fontconfig/57-dejavu-serif.conf
)
FONT_S="ttf"
FONT_SUFFIX="ttf"

src_unpack() {
	default
	if use fontforge; then
		mv "${MY_SP}" "${P}" || die
	else
		mv "${MY_BP}" "${P}" || die
	fi
}

src_prepare() {
	default
	xdg_environment_reset
}

src_compile() {
	if use fontforge; then
		emake \
			BUILDDIR=ttf \
			BLOCKS=/usr/share/unicode-data/Blocks.txt \
			UNICODEDATA=/usr/share/unicode-data/UnicodeData.txt \
			FC-LANG=/usr/share/fc-lang \
			full sans
	fi
}

src_install() {
	font_src_install
	if use fontforge; then
		dodoc ttf/*.txt
	fi
}
