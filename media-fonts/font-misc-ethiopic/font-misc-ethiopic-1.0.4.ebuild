# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
FONT_DIR="OTF"

XORG_PACKAGE_NAME="misc-ethiopic"
inherit xorg-3

DESCRIPTION="Miscellaneous Ethiopic fonts"

KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

XORG_CONFIGURE_OPTIONS=(
	--with-fontrootdir="${EPREFIX}/usr/share/fonts"

	# This flag unexpectedly doesn't control whether the font (i.e. the .ttf file)
	# is installed, but instead only controls whether mkfontscale/mkfontdir is
	# run. I suspect this is a bug.
	--disable-truetype-install
)

src_install() {
	xorg-3_src_install

	# TTF fonts are not supposed to be installed.
	rm -r "${ED}/usr/share/fonts/TTF" || die
}
