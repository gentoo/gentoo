# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="The package of IBM's typeface"
HOMEPAGE="https://github.com/IBM/plex"
SRC_URI="https://github.com/IBM/plex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~riscv x86"
IUSE="otf +ttf"

REQUIRED_USE="^^ ( otf ttf )"

S="${WORKDIR}/${P/ibm-}"

DOCS=( README.md )

FONT_SUFFIX=""

src_install() {

if use otf; then

	FONT_SUFFIX+="otf"

	FONT_S=(
		IBM-Plex-Mono/fonts/complete/otf
		IBM-Plex-Sans/fonts/complete/otf
		IBM-Plex-Sans-Arabic/fonts/complete/otf
		IBM-Plex-Sans-KR/fonts/complete/otf
		IBM-Plex-Sans-Condensed/fonts/complete/otf
		IBM-Plex-Sans-Devanagari/fonts/complete/otf
		IBM-Plex-Sans-Hebrew/fonts/complete/otf
		IBM-Plex-Serif/fonts/complete/otf
		IBM-Plex-Sans-Thai/fonts/complete/otf
		IBM-Plex-Sans-Thai-Looped/fonts/complete/otf )
fi

if use ttf; then

	FONT_SUFFIX+="ttf"

	FONT_S=(
		IBM-Plex-Mono/fonts/complete/ttf
		IBM-Plex-Sans-Arabic/fonts/complete/ttf
		IBM-Plex-Sans-KR/fonts/complete/ttf/hinted
		IBM-Plex-Sans-KR/fonts/complete/ttf/unhinted
		IBM-Plex-Sans-Condensed/fonts/complete/ttf
		IBM-Plex-Sans-Devanagari/fonts/complete/ttf
		IBM-Plex-Sans-Hebrew/fonts/complete/ttf
		IBM-Plex-Sans/fonts/complete/ttf
		IBM-Plex-Serif/fonts/complete/ttf
		IBM-Plex-Sans-Thai/fonts/complete/ttf
		IBM-Plex-Sans-Thai-Looped/fonts/complete/ttf
		IBM-Plex-Sans-Variable/fonts/complete/ttf )
fi

font_src_install

}
