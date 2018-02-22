# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

XORG_DRI=dri
XORG_EAUTORECONF=yes
inherit linux-info xorg-2 flag-o-matic

DESCRIPTION="X.Org driver for Intel cards"

KEYWORDS="~amd64 ~x86"
IUSE="debug dri3 +sna tools +udev uxa xvmc"
COMMIT_ID="4798e18b2b2c8b0a05dc967e6140fd9962bc1a73"
SRC_URI="https://cgit.freedesktop.org/xorg/driver/xf86-video-intel/snapshot/${COMMIT_ID}.tar.xz -> ${P}.tar.xz"

S=${WORKDIR}/${COMMIT_ID}

REQUIRED_USE="
	|| ( sna uxa )
"
RDEPEND="
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXScrnSaver
	>=x11-libs/pixman-0.27.1
	>=x11-libs/libdrm-2.4.52[video_cards_intel]
	dri3? (
		>=x11-base/xorg-server-1.18
		!<=media-libs/mesa-12.0.4
	)
	sna? (
		>=x11-base/xorg-server-1.10
	)
	tools? (
		x11-libs/libX11
		x11-libs/libxcb
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libxshmfence
		x11-libs/libXtst
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
		$(use_enable tools)
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
}
