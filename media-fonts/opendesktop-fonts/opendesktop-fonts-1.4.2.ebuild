# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

DESCRIPTION="Chinese TrueType Fonts"
HOMEPAGE="http://www.opendesktop.org.tw/"
SRC_URI="ftp://ftp.opendesktop.org.tw/odp/ODOFonts/OpenFonts/${P}.tar.gz"

LICENSE="Arphic"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

FONT_S="${S}"
FONT_SUFFIX="ttf ttc"
FONT_CONF=( "69-odofonts.conf"
	"80-odofonts-original.conf"
	"80-odofonts-simulate-MS-simplified-chinese.conf"
	"80-odofonts-simulate-MS-triditional-chinese.conf" )

DOCS="AUTHORS Changelog*"
