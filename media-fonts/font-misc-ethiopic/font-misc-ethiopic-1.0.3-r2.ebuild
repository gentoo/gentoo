# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
FONT_DIR="OTF"

inherit xorg-3

DESCRIPTION="Miscellaneous Ethiopic fonts"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

FONT_OPTIONS="--with-otf-fontdir=${EPREFIX}/usr/share/fonts/OTF"

src_install() {
	xorg-3_src_install
	# TTF fonts are not supposed to be installed.
	# Also fixes file collision per bug #309689
	rm -r "${ED}/usr/share/fonts/TTF" || die
}
