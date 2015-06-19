# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/kacst-fonts/kacst-fonts-2.0.ebuild,v 1.4 2011/12/14 16:39:52 ago Exp $

inherit font

MY_PN="KacstArabicFonts"
S=${WORKDIR}/${MY_PN}-${PV}

DESCRIPTION="KACST Arabic TrueType Fonts"
HOMEPAGE="http://www.arabeyes.org/project.php?proj=Khotot"
SRC_URI="mirror://sourceforge/arabeyes/${P//-/_}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

FONT_SUFFIX="ttf"

FONT_S=${S}
