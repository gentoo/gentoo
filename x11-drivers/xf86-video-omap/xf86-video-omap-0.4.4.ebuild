# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
XORG_DRI=always
inherit xorg-2

DESCRIPTION="OMAP video driver"

KEYWORDS="arm"

RDEPEND=">=x11-base/xorg-server-1.3
	>=x11-libs/libdrm-2.4.36[video_cards_omap]"
DEPEND="${RDEPEND}"
