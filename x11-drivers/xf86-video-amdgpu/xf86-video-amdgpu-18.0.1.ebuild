# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
XORG_DRI="always"
inherit xorg-2

if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Accelerated Open Source driver for AMDGPU cards"

RDEPEND=">=x11-libs/libdrm-2.4.78[video_cards_amdgpu]
	x11-base/xorg-server[glamor(-)]"
DEPEND="${RDEPEND}"

src_configure() {
	XORG_CONFIGURE_OPTIONS="--enable-glamor"
	xorg-2_src_configure
}
