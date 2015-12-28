# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Displays info about your card's VDPAU support"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/VDPAU"
SRC_URI="http://people.freedesktop.org/~aplattner/vdpau/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/libX11
	>=x11-libs/libvdpau-1.0
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto
"
