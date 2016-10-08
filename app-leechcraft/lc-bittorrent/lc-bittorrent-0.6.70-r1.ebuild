# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit leechcraft

DESCRIPTION="Full-featured BitTorrent client plugin for LeechCraft"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug geoip"

DEPEND="
	~app-leechcraft/lc-core-${PV}
	net-libs/rb_libtorrent:=
"
RDEPEND="${DEPEND}
	virtual/leechcraft-task-show
	geoip? ( dev-libs/geoip )
"

PATCHES=(
	"${FILESDIR}"/${P}-libtorrent1.patch
)

src_configure(){
	cmake-utils_src_configure \
		$(cmake-utils_use_enable geoip BITTORRENT_GEOIP)
}
