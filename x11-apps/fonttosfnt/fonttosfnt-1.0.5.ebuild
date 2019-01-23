# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org fonttosfnt application"
KEYWORDS="amd64 arm ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""
RDEPEND="x11-libs/libX11
	=media-libs/freetype-2*
	x11-libs/libfontenc"
DEPEND="${RDEPEND}"
