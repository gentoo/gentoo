# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
XORG_DRI="always"
XORG_EAUTORECONF=yes
inherit xorg-2

if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="mirror://gentoo/${P}.tar.xz"
	KEYWORDS="amd64 ~x86"
fi

DESCRIPTION="Accelerated Open Source driver for AMDGPU cards"

IUSE="glamor"

RDEPEND="x11-libs/libdrm[video_cards_amdgpu]
	x11-base/xorg-server[glamor(-)?]"
DEPEND="${RDEPEND}"

src_configure() {
	XORG_CONFIGURE_OPTIONS="$(use_enable glamor)"
	xorg-2_src_configure
}
