# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/farsi-fonts/farsi-fonts-0.4.ebuild,v 1.14 2011/06/14 17:33:56 grobian Exp $

inherit font

S=${WORKDIR}/${P/-/}

DESCRIPTION="Farsi (Persian) Unicode fonts"
HOMEPAGE="http://www.farsiweb.ir/wiki/Products/PersianFonts"
SRC_URI="http://www.farsiweb.ir/font/farsifonts-${PV}.zip"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc s390 sh sparc x86 ~x86-fbsd ~ppc-macos ~x86-macos"
IUSE=""

FONT_SUFFIX="ttf"
FONT_S="${S}"

DEPEND="app-arch/unzip"
RDEPEND=""
