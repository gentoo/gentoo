# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="VirtualBox guest video driver"
HOMEPAGE="https://cgit.freedesktop.org/xorg/driver/xf86-video-vbox/"

KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=x11-base/xorg-server-1.8:=[-minimal]
	x11-libs/libXcomposite
	x11-libs/libpciaccess
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
