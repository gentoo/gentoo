# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="An utility for setting opacity property"

LICENSE="SGI-B-2.0"
KEYWORDS="amd64 ~ppc64 x86"

RDEPEND="x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
