# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A wrapper script to start Compiz 0.8.x with proper options"
HOMEPAGE="https://github.com/compiz-reloaded"
SRC_URI="https://github.com/compiz-reloaded/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-apps/mesa-progs
		x11-apps/xdpyinfo
		>=x11-wm/compiz-0.8.12
		<x11-wm/compiz-0.9
"

src_install() {
	dobin compiz-manager
}
