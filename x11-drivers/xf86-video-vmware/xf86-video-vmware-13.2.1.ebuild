# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DRI=always
inherit xorg-2

DESCRIPTION="VMware SVGA video driver"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE="kernel_linux"

RDEPEND="kernel_linux? (
		x11-libs/libdrm[libkms,video_cards_vmware]
		media-libs/mesa[xa]
	)"
DEPEND="${RDEPEND}"
