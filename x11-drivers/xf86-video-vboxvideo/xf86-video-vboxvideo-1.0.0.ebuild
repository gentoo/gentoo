# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_PACKAGE_NAME=xf86-video-vbox
inherit xorg-3

DESCRIPTION="VirtualBox guest video driver"

KEYWORDS="amd64 x86"

RDEPEND="
	!x11-drivers/xf86-video-virtualbox
	>=x11-base/xorg-server-1.8:=[-minimal]
	x11-libs/libXcomposite
	x11-libs/libpciaccess"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
