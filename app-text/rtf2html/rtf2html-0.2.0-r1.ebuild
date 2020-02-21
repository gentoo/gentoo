# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="RTF to HTML converter"
HOMEPAGE="http://rtf2html.sourceforge.net/"
SRC_URI="mirror://sourceforge/rtf2html/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-gcc43.patch )

src_prepare() {
	default

	# CFLAGS are incorrectly parsed, so handle this here
	sed -i -e '/CFLAGS=$(echo $CFLAGS/d' configure || die 'sed on configure failed'
}
