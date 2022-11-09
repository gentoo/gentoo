# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg

DESCRIPTION="Real-time Sunlight Wallpaper"
HOMEPAGE="http://realtimesunlightwallpaper.weebly.com/"
SRC_URI="https://ppa.launchpad.net/realtime.sunlight.wallpaper/rsw/ubuntu/pool/main/g/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-function-declarations.patch
)

src_compile() {
	tc-export CC
	default
}
