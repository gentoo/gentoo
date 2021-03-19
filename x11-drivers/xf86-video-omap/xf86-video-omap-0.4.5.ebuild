# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DRI=always
inherit xorg-3

DESCRIPTION="OMAP video driver"

KEYWORDS="arm"

RDEPEND="
	>=x11-base/xorg-server-1.3
	>=x11-libs/libdrm-2.4.36[video_cards_omap]"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-0.4.5-null-dereference.patch )
