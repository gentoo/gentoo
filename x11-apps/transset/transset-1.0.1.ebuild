# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="An utility for setting opacity property"

LICENSE="SGI-B-2.0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
