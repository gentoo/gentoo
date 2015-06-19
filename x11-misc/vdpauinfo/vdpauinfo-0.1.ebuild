# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/vdpauinfo/vdpauinfo-0.1.ebuild,v 1.1 2013/10/25 19:12:26 cardoe Exp $

EAPI=5

DESCRIPTION="Displays info about your card's VDPAU support"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/VDPAU"
SRC_URI="http://people.freedesktop.org/~aplattner/vdpau/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
		x11-libs/libvdpau"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		x11-proto/xproto"
