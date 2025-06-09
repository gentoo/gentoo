# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
GST_ORG_MODULE="gst-plugins-bad"
inherit gstreamer-meson

DESCRIPTION="Less plugins for GStreamer"
HOMEPAGE="https://gstreamer.freedesktop.org/"

LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

IUSE="X bzip2 +introspection +orc udev vaapi vnc wayland"

# X11 is automagic for now, upstream #709530 - only used by librfb USE=vnc plugin
# Baseline requirement for libva is 1.6, but 1.15 gets more features
RDEPEND="
	>=media-libs/gstreamer-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	>=media-libs/gst-plugins-base-${PV}:${SLOT}[${MULTILIB_USEDEP},introspection?]
	introspection? ( >=dev-libs/gobject-introspection-1.82.0:= )

	bzip2? ( >=app-arch/bzip2-1.0.8-r5[${MULTILIB_USEDEP}] )
	vnc? ( X? ( x11-libs/libX11[${MULTILIB_USEDEP}] ) )
	wayland? (
		>=dev-libs/wayland-protocols-1.41
		>=dev-libs/wayland-1.23.1[${MULTILIB_USEDEP}]
		>=x11-libs/libdrm-2.4.124[${MULTILIB_USEDEP}]
	)

	orc? ( >=dev-lang/orc-0.4.40[${MULTILIB_USEDEP}] )

	vaapi? (
		>=media-libs/libva-1.22.0:=[${MULTILIB_USEDEP}]
		udev? ( dev-libs/libgudev[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils"

DOCS=( AUTHORS ChangeLog NEWS README.md RELEASE )

PATCHES=(
	"${FILESDIR}"/0001-meson-no-lce-configure-checks.patch
	"${FILESDIR}"/0002-disable-aes-tests.patch
	"${FILESDIR}"/0003-meson_fix_building-bad_tests_with_disabled_soundtouch.patch
)

src_prepare() {
	default
	addpredict /dev # Prevent sandbox violations bug #570624
}

multilib_src_configure() {
	GST_PLUGINS_NOAUTO="bz2 hls ipcpipeline librfb shm va wayland"

	local emesonargs=(
		-Dshm=enabled
		-Dipcpipeline=enabled
		-Dhls=disabled
		$(meson_feature bzip2 bz2)
		$(meson_feature vaapi va)
		-Dudev=$(usex udev $(usex vaapi enabled disabled) disabled)
		$(meson_feature vnc librfb)
		-Dx11=$(usex X $(usex vnc enabled disabled) disabled)
		$(meson_feature wayland)
		$(meson_option wayland)
	)

	gstreamer_multilib_src_configure
}

multilib_src_test() {
	# Tests are slower than upstream expects
	CK_DEFAULT_TIMEOUT=300 gstreamer_multilib_src_test
}
