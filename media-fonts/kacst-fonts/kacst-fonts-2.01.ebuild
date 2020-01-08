# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

MY_PN="KacstArabicFonts"
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="KACST Arabic TrueType Fonts"
HOMEPAGE="http://www.arabeyes.org/project.php?proj=Khotot"
SRC_URI="mirror://sourceforge/arabeyes/${P//-/_}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~s390 ~sh ~sparc x86"
IUSE=""

FONT_SUFFIX="ttf"

FONT_S=${S}
