# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="The package of IBM's typeface"
HOMEPAGE="https://github.com/IBM/plex"
SRC_URI="https://github.com/IBM/plex/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="otf +ttf"

REQUIRED_USE="^^ ( otf ttf )"

S="${WORKDIR}/${P/ibm-}"

DOCS=( README.md )

FONT_SUFFIX=""

src_install() {

if use otf; then

	FONT_SUFFIX+="otf"

	FONT_S="
		"${S}"/IBM-Plex-Mono/fonts/complete/otf
		"${S}"/IBM-Plex-Sans-Condensed/fonts/complete/otf
		"${S}"/IBM-Plex-Sans-Devanagari/fonts/complete/otf
		"${S}"/IBM-Plex-Sans-Hebrew/fonts/complete/otf
		"${S}"/IBM-Plex-Sans/fonts/complete/otf
		"${S}"/IBM-Plex-Serif/fonts/complete/otf
		"${S}"/IBM-Plex-Sans-Thai-Looped/fonts/complete/otf
		"${S}"/IBM-Plex-Sans-Variable/fonts/complete/otf"
fi

if use ttf; then

	FONT_SUFFIX+="ttf"

	FONT_S="
		"${S}"/IBM-Plex-Mono/fonts/complete/ttf
		"${S}"/IBM-Plex-Sans-Condensed/fonts/complete/ttf
		"${S}"/IBM-Plex-Sans-Devanagari/fonts/complete/ttf
		"${S}"/IBM-Plex-Sans-Hebrew/fonts/complete/ttf
		"${S}"/IBM-Plex-Sans/fonts/complete/ttf
		"${S}"/IBM-Plex-Serif/fonts/complete/ttf
		"${S}"/IBM-Plex-Sans-Thai-Looped/fonts/complete/ttf
		"${S}"/IBM-Plex-Sans-Variable/fonts/complete/ttf"
fi

font_src_install

}
