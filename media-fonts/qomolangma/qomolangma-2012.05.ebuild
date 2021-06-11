# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Tibetan Unicode Ucan and Umed fonts"
HOMEPAGE="http://www.yalasoo.com/English/docs/yalasoo_en_font.html"
SRC_URI="http://www.yalasoo.com/files/CTRCfonts.rar -> ${P}.rar"
S="${WORKDIR}"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

BDEPEND="|| ( app-arch/unrar app-arch/rar )"

FONT_SUFFIX="ttf"
