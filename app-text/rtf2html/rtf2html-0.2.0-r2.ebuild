# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="RTF to HTML converter"
HOMEPAGE="http://rtf2html.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/rtf2html/${P}.tar.bz2
	https://github.com/lvu/rtf2html/raw/4b0e5a3cca2d0c81ee50dcfaa7e3d3dd0a89e59b/stlport.m4 -> ${P}-stlport.m4
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	# make autoreconf work
	# https://github.com/lvu/rtf2html/pull/12
	"${FILESDIR}"/buildsystem-fixes.patch
)

src_prepare() {
	cp "${DISTDIR}"/${P}-stlport.m4 stlport.m4 || die
	default
	eautoreconf

	# CFLAGS are incorrectly parsed, so handle this here
	sed -i -e '/CFLAGS=$(echo $CFLAGS/d' configure || die 'sed on configure failed'
}
