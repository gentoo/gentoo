# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit leechcraft

DESCRIPTION="Full-featured BitTorrent client plugin for LeechCraft"

SLOT="0"
KEYWORDS=""
IUSE="debug geoip"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	net-libs/libtorrent-rasterbar:=
	geoip? ( dev-libs/libmaxminddb:= )
"
RDEPEND="${DEPEND}
	virtual/leechcraft-task-show
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BITTORRENT_GEOIP=$(usex geoip)
	)
	cmake_src_configure
}
