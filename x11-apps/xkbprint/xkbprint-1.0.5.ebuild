# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Print an XKB keyboard description"
KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 ~s390 ~sparc x86"
IUSE=""
RDEPEND="x11-libs/libxkbfile
	>=x11-libs/libX11-1.6.9"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
