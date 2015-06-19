# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-freedreno/xf86-video-freedreno-1.1.0.ebuild,v 1.2 2014/06/05 15:41:48 chithanh Exp $

EAPI=5

XORG_DRI=always
inherit xorg-2

DESCRIPTION="Driver for Adreno mobile GPUs"
KEYWORDS="~arm"
IUSE=""

RDEPEND=">=media-libs/mesa-10.2[xa]
	virtual/libudev
	>=x11-libs/libdrm-2.4.54[video_cards_freedreno]"
DEPEND="${RDEPEND}"
