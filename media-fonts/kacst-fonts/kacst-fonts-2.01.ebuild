# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="KACST Arabic TrueType Fonts"
HOMEPAGE="https://www.arabeyes.org/Khotot https://gitlab.com/arabeyes-art/khotot"
SRC_URI="mirror://sourceforge/arabeyes/${P//-/_}.tar.bz2"
S="${WORKDIR}/KacstArabicFonts-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~s390 ~sparc x86"
IUSE=""

FONT_SUFFIX="ttf"
