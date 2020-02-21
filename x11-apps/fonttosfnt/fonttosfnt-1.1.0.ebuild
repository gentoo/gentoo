# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xorg-3

DESCRIPTION="X.Org fonttosfnt application"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""
RDEPEND="media-libs/freetype:2
	x11-libs/libX11
	x11-libs/libfontenc"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
