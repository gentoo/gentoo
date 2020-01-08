# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Farsi (Persian) Unicode fonts"
HOMEPAGE="http://www.farsiweb.ir/wiki/Products/PersianFonts"
SRC_URI="http://www.farsiweb.ir/font/farsifonts-${PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc s390 sh sparc x86 ~ppc-macos ~x86-macos"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/${P/-/}"

FONT_S="${S}"
FONT_SUFFIX="ttf"
