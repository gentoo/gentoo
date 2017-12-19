# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="VirtualBox guest video driver"
HOMEPAGE="https://cgit.freedesktop.org/xorg/driver/xf86-video-vbox/"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=x11-base/xorg-server-1.8:=[-minimal]
	x11-libs/libXcomposite
"
DEPEND="
	${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-libs/libpciaccess
"
