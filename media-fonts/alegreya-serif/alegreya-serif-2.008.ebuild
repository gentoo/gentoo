# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="Alegreya"
inherit font

DESCRIPTION="Alegreya serif type family"
HOMEPAGE="https://www.huertatipografica.com/en/fonts/alegreya-ht-pro"
SRC_URI="https://github.com/huertatipografica/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DOCS=( CONTRIBUTORS.txt README.md )

FONT_S="${S}/fonts/otf"
FONT_SUFFIX="otf"
