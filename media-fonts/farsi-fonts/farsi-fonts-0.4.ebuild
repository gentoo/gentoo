# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit font

S=${WORKDIR}/${P/-/}

DESCRIPTION="Farsi (Persian) Unicode fonts"
HOMEPAGE="http://www.farsiweb.ir/wiki/Products/PersianFonts"
SRC_URI="http://www.farsiweb.ir/font/farsifonts-${PV}.zip"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc s390 sh sparc x86 ~ppc-macos ~x86-macos"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${S}"

DEPEND="app-arch/unzip"
RDEPEND=""
