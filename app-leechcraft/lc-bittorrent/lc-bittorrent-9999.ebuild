# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit leechcraft

DESCRIPTION="Full-featured BitTorrent client plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug geoip"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	net-libs/libtorrent-rasterbar
	dev-qt/qtxml:5
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	virtual/leechcraft-task-show
	geoip? ( dev-libs/geoip )
"

src_configure(){
	local mycmakeargs=(
		-DENABLE_BITTORRENT_GEOIP=$(usex geoip)
	)
	cmake-utils_src_configure
}
