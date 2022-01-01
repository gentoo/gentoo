# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_DRI=dri
XORG_EAUTORECONF=yes
inherit linux-info xorg-3 flag-o-matic

if [[ ${PV} == 9999* ]]; then
	SRC_URI=""
else
	KEYWORDS="amd64 x86"
	COMMIT_ID="5ca3ac1a90af177eb111a965e9b4dd8a27cc58fc"
	SRC_URI="https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel/-/archive/${COMMIT_ID}/${P}.tar.bz2"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
fi

DESCRIPTION="X.Org driver for Intel cards"

IUSE="debug +sna tools +udev uxa xvmc"

REQUIRED_USE="
	|| ( sna uxa )
"
RDEPEND="
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXScrnSaver
	>=x11-libs/pixman-0.27.1
	>=x11-libs/libdrm-2.4.52[video_cards_intel]
	>=x11-base/xorg-server-1.18
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
		virtual/libudev:=
	)
	xvmc? (
		x11-libs/libXvMC
		>=x11-libs/libxcb-1.5
		x11-libs/xcb-util
	)
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${PN}-gcc-pr65873.patch
)

src_configure() {
	replace-flags -Os -O2
	XORG_CONFIGURE_OPTIONS=(
		--disable-dri1
		$(use_enable debug)
		$(use_enable dri)
		$(use_enable dri dri3)
		$(usex dri "--with-default-dri=3")
		$(use_enable sna)
		$(use_enable tools)
		$(use_enable udev)
		$(use_enable uxa)
		$(use_enable xvmc)
	)
	xorg-3_src_configure
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
