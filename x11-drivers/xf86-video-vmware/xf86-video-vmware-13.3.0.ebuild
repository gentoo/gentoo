# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DRI=always
inherit xorg-3

DESCRIPTION="VMware SVGA video driver"

KEYWORDS="amd64 x86"
IUSE="kernel_linux"

RDEPEND="
	kernel_linux? (
		x11-libs/libdrm[libkms,video_cards_vmware]
		media-libs/mesa[xa]
	)"
DEPEND="${RDEPEND}"
