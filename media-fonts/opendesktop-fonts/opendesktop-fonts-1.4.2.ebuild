# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit font

DESCRIPTION="Chinese TrueType Fonts"
#HOMEPAGE="http://www.opendesktop.org.tw/"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="Arphic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc s390 sh sparc x86"
IUSE=""

FONT_SUFFIX="ttf ttc"
FONT_S="${S}"
FONT_CONF=(
	"69-odofonts.conf"
	"80-odofonts-original.conf"
	"80-odofonts-simulate-MS-simplified-chinese.conf"
	"80-odofonts-simulate-MS-triditional-chinese.conf"
)
DOCS="AUTHORS Changelog*"
