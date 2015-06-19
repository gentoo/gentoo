# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ati/xf86-video-ati-7.4.0.ebuild,v 1.1 2014/06/26 10:28:25 chithanh Exp $

EAPI=5

XORG_DRI=always
inherit linux-info xorg-2

DESCRIPTION="ATI video driver"

KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+glamor udev"

RDEPEND=">=x11-libs/libdrm-2.4.54[video_cards_radeon]
	glamor? ( || (
		x11-base/xorg-server[glamor]
		>=x11-libs/glamor-0.6
	) )
	udev? ( virtual/udev )"
DEPEND="${RDEPEND}"

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
