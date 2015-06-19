# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-intel/xf86-video-intel-2.99.906.ebuild,v 1.1 2013/11/17 22:20:35 chithanh Exp $

EAPI=5

XORG_DRI=dri
inherit linux-info xorg-2

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="~amd64 ~x86 ~amd64-fbsd -x86-fbsd"
IUSE="glamor +sna +udev uxa xvmc"

REQUIRED_USE="
	|| ( sna uxa )
	glamor? ( uxa )
"

RDEPEND="x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/pixman-0.27.1
	>=x11-libs/libdrm-2.4.29[video_cards_intel]
	glamor? (
		x11-libs/glamor
	)
	sna? (
		>=x11-base/xorg-server-1.10
	)
	udev? (
		virtual/udev
	)
	xvmc? (
		x11-libs/libXvMC
		>=x11-libs/libxcb-1.5
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}
	>=x11-proto/dri2proto-2.6
	x11-proto/resourceproto"

PATCHES=(
	"${FILESDIR}"/${P}-server-crash.patch
)

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable dri)
		$(use_enable glamor)
		$(use_enable sna)
		$(use_enable uxa)
		$(use_enable udev)
		$(use_enable xvmc)
	)
	xorg-2_src_configure
}

pkg_postinst() {
	if linux_config_exists \
		&& ! linux_chkconfig_present DRM_I915_KMS; then
		echo
		ewarn "This driver requires KMS support in your kernel"
		ewarn "  Device Drivers --->"
		ewarn "    Graphics support --->"
		ewarn "      Direct Rendering Manager (XFree86 4.1.0 and higher DRI support)  --->"
		ewarn "      <*>   Intel 830M, 845G, 852GM, 855GM, 865G (i915 driver)  --->"
		ewarn "	      i915 driver"
		ewarn "      [*]       Enable modesetting on intel by default"
		echo
	fi
}
