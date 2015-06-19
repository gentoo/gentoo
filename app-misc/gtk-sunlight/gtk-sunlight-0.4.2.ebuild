# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gtk-sunlight/gtk-sunlight-0.4.2.ebuild,v 1.1 2012/06/11 08:28:29 xmw Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="Real-time Sunlight Wallpaper"
HOMEPAGE="http://realtimesunlightwallpaper.weebly.com/"
SRC_URI="http://ppa.launchpad.net/realtime.sunlight.wallpaper/rsw/ubuntu/pool/main/g/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${REPEND}
	virtual/pkgconfig"

src_compile() {
	tc-export CC
	default
}
