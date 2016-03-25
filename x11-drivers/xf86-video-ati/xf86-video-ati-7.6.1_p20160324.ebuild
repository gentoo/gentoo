# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DRI=always
XORG_EAUTORECONF=yes
inherit linux-info xorg-2

DESCRIPTION="ATI video driver"
HOMEPAGE="http://www.x.org/wiki/ati/"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="+glamor udev"
COMMIT_ID="8a6cd4bda05b9569b3dd0a5a75b2cc385b9ecba9"
SRC_URI="http://cgit.freedesktop.org/xorg/driver/xf86-video-ati/snapshot/${COMMIT_ID}.tar.xz -> ${P}.tar.xz"

S=${WORKDIR}/${COMMIT_ID}

RDEPEND=">=x11-libs/libdrm-2.4.58[video_cards_radeon]
	>=x11-libs/libpciaccess-0.8.0
	glamor? ( x11-base/xorg-server[glamor] )
	udev? ( virtual/udev )"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86driproto
	x11-proto/xproto"

pkg_pretend() {
	if use kernel_linux ; then
		if kernel_is -ge 3 9; then
			CONFIG_CHECK="~!DRM_RADEON_UMS ~!FB_RADEON"
		else
			CONFIG_CHECK="~DRM_RADEON_KMS ~!FB_RADEON"
		fi
	fi
	check_extra_config
}

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable glamor)
		$(use_enable udev)
	)
	xorg-2_src_configure
}
