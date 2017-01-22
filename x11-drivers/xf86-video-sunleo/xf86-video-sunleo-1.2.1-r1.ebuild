# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

EAPI=5
inherit xorg-2

DESCRIPTION="Leo video driver"
KEYWORDS="-* ~sparc"
RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xproto"

PATCHES=(
	"${FILESDIR}"/${P}-drop-mifillarc.patch
	"${FILESDIR}"/${P}-drop-miwideline.patch
)
