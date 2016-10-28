# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_DRI=dri
XORG_EAUTORECONF=yes
inherit linux-info xorg-2 flag-o-matic

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="~amd64 ~x86 ~amd64-fbsd -x86-fbsd"
IUSE="debug dri3 +sna +udev uxa xvmc"
COMMIT_ID="325570e731b5819e28ce6bae72242914bb2d7f8e"
SRC_URI="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/${COMMIT_ID}.tar.xz -> ${P}.tar.xz"

S=${WORKDIR}/${COMMIT_ID}

REQUIRED_USE="
	|| ( sna uxa )
"
RDEPEND="x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/pixman-0.27.1
	>=x11-libs/libdrm-2.4.29[video_cards_intel]
	dri3? (
		>=x11-base/xorg-server-1.18
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
	x11-proto/dri3proto
	x11-proto/presentproto
	x11-proto/resourceproto"

src_configure() {
	replace-flags -Os -O2
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable debug)
		$(use_enable dri)
		$(use_enable dri dri3)
		$(usex dri3 "--with-default-dri=3")
		$(use_enable sna)
		$(use_enable udev)
		$(use_enable uxa)
		$(use_enable xvmc)
	)
	xorg-2_src_configure
}

pkg_postinst() {
	if linux_config_exists && \
		kernel_is -lt 4 3 && ! linux_chkconfig_present DRM_I915_KMS; then
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
	if use dri3; then
		ewarn "There are reports of crashes when using DRI3, we recommend"
		ewarn "to be careful when enabling this option. Check the following"
		ewarn "bugs for discussion and a workaround patch for libdrm:"
		ewarn "https://bugs.freedesktop.org/show_bug.cgi?id=71759"
		ewarn "https://bugs.gentoo.org/show_bug.cgi?id=582544"
	fi
}
