# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit font

DESCRIPTION="Tibetan Unicode Ucan and Umed fonts"
HOMEPAGE="http://www.yalasoo.com/English/docs/yalasoo_en_font.html"
SRC_URI="http://www.yalasoo.com/files/CTRCfonts.rar -> ${P}.rar"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="|| ( app-arch/unrar app-arch/rar )"

S=${WORKDIR}
FONT_S=${S}
FONT_SUFFIX="ttf"
