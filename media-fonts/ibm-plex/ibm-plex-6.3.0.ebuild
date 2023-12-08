# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="The package of IBM's typeface"
HOMEPAGE="https://github.com/IBM/plex"
SRC_URI="https://github.com/IBM/plex/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/ibm-}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv x86"
IUSE="eot otf +ttf woff woff2"

REQUIRED_USE="^^ ( eot otf ttf woff woff2 )"

DOCS=( README.md )

FONT_SUFFIX=""

src_install() {

if use eot; then

	FONT_SUFFIX+="eot"

	FONT_S=(
		IBM-Plex-Mono/fonts/complete/eot
		IBM-Plex-Sans-Arabic/fonts/complete/eot
		IBM-Plex-Sans-Condensed/fonts/complete/eot
		IBM-Plex-Sans-Devanagari/fonts/complete/eot
		IBM-Plex-Sans-Hebrew/fonts/complete/eot
		IBM-Plex-Sans-KR/fonts/complete/eot/hinted
		IBM-Plex-Sans-KR/fonts/complete/eot/unhinted
		IBM-Plex-Sans-Thai-Looped/fonts/complete/eot
		IBM-Plex-Sans-Thai/fonts/complete/eot
		IBM-Plex-Sans/fonts/complete/eot
		IBM-Plex-Serif/fonts/complete/eot )
fi

if use otf; then

	FONT_SUFFIX+="otf"

	FONT_S=(
		IBM-Plex-Mono/fonts/complete/otf
		IBM-Plex-Sans-Arabic/fonts/complete/otf
		IBM-Plex-Sans-Condensed/fonts/complete/otf
		IBM-Plex-Sans-Devanagari/fonts/complete/otf
		IBM-Plex-Sans-Hebrew/fonts/complete/otf
		IBM-Plex-Sans-JP/fonts/complete/otf/hinted
		IBM-Plex-Sans-JP/fonts/complete/otf/unhinted
		IBM-Plex-Sans-KR/fonts/complete/otf
		IBM-Plex-Sans-Thai-Looped/fonts/complete/otf
		IBM-Plex-Sans-Thai/fonts/complete/otf
		IBM-Plex-Sans/fonts/complete/otf
		IBM-Plex-Serif/fonts/complete/otf )
fi

if use ttf; then

	FONT_SUFFIX+="ttf"

	FONT_S=(
		IBM-Plex-Mono/fonts/complete/ttf
		IBM-Plex-Sans-Arabic/fonts/complete/ttf
		IBM-Plex-Sans-Condensed/fonts/complete/ttf
		IBM-Plex-Sans-Devanagari/fonts/complete/ttf
		IBM-Plex-Sans-Hebrew/fonts/complete/ttf
		IBM-Plex-Sans-JP/fonts/complete/ttf/hinted
		IBM-Plex-Sans-JP/fonts/complete/ttf/unhinted
		IBM-Plex-Sans-KR/fonts/complete/ttf/hinted
		IBM-Plex-Sans-KR/fonts/complete/ttf/unhinted
		IBM-Plex-Sans-Thai-Looped/fonts/complete/ttf
		IBM-Plex-Sans-Thai/fonts/complete/ttf
		IBM-Plex-Sans-Variable/fonts/complete/ttf
		IBM-Plex-Sans/fonts/complete/ttf
		IBM-Plex-Serif/fonts/complete/ttf )
fi

if use woff; then

	FONT_SUFFIX+="woff"

	FONT_S=(
		IBM-Plex-Mono/fonts/complete/woff
		IBM-Plex-Sans-Arabic/fonts/complete/woff
		IBM-Plex-Sans-Condensed/fonts/complete/woff
		IBM-Plex-Sans-Devanagari/fonts/complete/woff
		IBM-Plex-Sans-Hebrew/fonts/complete/woff
		IBM-Plex-Sans-JP/fonts/complete/woff/hinted
		IBM-Plex-Sans-JP/fonts/complete/woff/unhinted
		IBM-Plex-Sans-KR/fonts/complete/woff/hinted
		IBM-Plex-Sans-KR/fonts/complete/woff/unhinted
		IBM-Plex-Sans-Thai-Looped/fonts/complete/woff
		IBM-Plex-Sans-Thai/fonts/complete/woff
		IBM-Plex-Sans-Variable/fonts/complete/woff
		IBM-Plex-Sans/fonts/complete/woff
		IBM-Plex-Serif/fonts/complete/woff )
fi

if use woff2; then

	FONT_SUFFIX+="woff2"

	FONT_S=(
		IBM-Plex-Mono/fonts/complete/woff2
		IBM-Plex-Sans-Arabic/fonts/complete/woff2
		IBM-Plex-Sans-Condensed/fonts/complete/woff2
		IBM-Plex-Sans-Devanagari/fonts/complete/woff2
		IBM-Plex-Sans-Hebrew/fonts/complete/woff2
		IBM-Plex-Sans-JP/fonts/complete/woff2/hinted
		IBM-Plex-Sans-JP/fonts/complete/woff2/unhinted
		IBM-Plex-Sans-KR/fonts/complete/woff2/hinted
		IBM-Plex-Sans-KR/fonts/complete/woff2/unhinted
		IBM-Plex-Sans-Thai-Looped/fonts/complete/woff2
		IBM-Plex-Sans-Thai/fonts/complete/woff2
		IBM-Plex-Sans-Variable/fonts/complete/woff2
		IBM-Plex-Sans/fonts/complete/woff2
		IBM-Plex-Serif/fonts/complete/woff2 )
fi

font_src_install

}
