# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
FONT_DIR="OTF"

inherit xorg-2

DESCRIPTION="Miscellaneous Ethiopic fonts"

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	x11-apps/bdftopcf"

FONT_OPTIONS="--with-otf-fontdir=${EPREFIX}usr/share/fonts/OTF"

src_install() {
	xorg-2_src_install
	# TTF fonts are not supposed to be installed.
	# Also fixes file collision per bug #309689
	rm -rf "${D}/${EPREFIX}usr/share/fonts/TTF"
}
