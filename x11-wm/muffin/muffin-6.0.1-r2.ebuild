# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit gnome2-utils meson python-any-r1 virtualx

DESCRIPTION="Compositing window manager forked from Mutter for use with Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/muffin"
SRC_URI="https://github.com/linuxmint/muffin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+ MIT SGI-B-2.0"
SLOT="0"
IUSE="input_devices_wacom +introspection screencast sysprof systemd test udev wayland video_cards_nvidia"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv x86"
REQUIRED_USE="wayland? ( udev )"

# Dependencies listed in meson order
COMDEPEND="
	x11-libs/libX11
	>=media-libs/graphene-1.9.3[introspection?]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/pango-1.20.0[introspection?]
	>=x11-libs/cairo-1.10.0[X]
	>=dev-libs/fribidi-1.0.0
	>=dev-libs/glib-2.61.1:2
	>=dev-libs/json-glib-0.12.0[introspection?]
	>=gnome-extra/cinnamon-desktop-5.8:0=
	>=x11-libs/libXcomposite-0.4
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	>=x11-libs/libXfixes-3
	>=x11-libs/libXi-1.7.4
	x11-libs/libXtst
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-libs/libXrender
	>=x11-libs/libXrandr-1.5.0
	x11-libs/libxcb:=
	x11-libs/libXinerama
	x11-libs/libXau
	x11-libs/libICE
	>=app-accessibility/at-spi2-core-2.46.0:2[introspection?]
	>=media-libs/libcanberra-0.26
	sys-apps/dbus
	media-libs/libglvnd[X]
	media-libs/mesa[X(+),egl(+)]
	x11-libs/libSM
	>=x11-libs/startup-notification-0.7
	media-libs/fontconfig

	input_devices_wacom? (
		>=dev-libs/libwacom-0.13:=
	)
	introspection? (
		>=dev-libs/gobject-introspection-1.41.3:=
	)
	screencast? (
		>=media-video/pipewire-0.3.0:=
	)
	sysprof? (
		>=dev-util/sysprof-capture-3.35.2:3
	)
	udev? (
		>=virtual/libudev-228:=
		>=dev-libs/libgudev-232
	)
	wayland? (
		>=dev-libs/libinput-1.7:=
		>=dev-libs/wayland-1.13.0
		>=dev-libs/wayland-protocols-1.19
		|| (
			>=media-libs/mesa-24.1.0_rc1[opengl]
			<media-libs/mesa-24.1.0_rc1[gbm(+),gles2]
		)
		x11-base/xwayland
		x11-libs/libdrm

		systemd? (
			sys-apps/systemd
		)
		!systemd? (
			sys-auth/elogind
		)
		video_cards_nvidia? (
			gui-libs/egl-wayland
		)
	)
"
RDEPEND="${COMDEPEND}
	gnome-extra/zenity
"
DEPEND="${COMDEPEND}
	x11-base/xorg-proto

	sysprof? (
		dev-util/sysprof-common
	)
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig

	wayland? (
		dev-util/wayland-scanner
		>=sys-kernel/linux-headers-4.4
		x11-libs/libxcvt
	)
"

PATCHES=(
	# -Werror=incompatible-pointer-types
	# https://bugs.gentoo.org/919091
	# https://github.com/linuxmint/muffin/pull/683
	"${FILESDIR}"/38919a88b2b8381f5b24b69742d1b9db32029c61.patch
)

src_prepare() {
	default
	python_fix_shebang src/backends/native/gen-default-modes.py
}

# Wayland is not supported upstream.
src_configure() {
	local emesonargs=(
		-Dopengl=true
		#opengl_libname
		#gles2_libname
		$(meson_use wayland gles2)
		-Degl=true
		-Dglx=true
		$(meson_use wayland)
		$(meson_use wayland native_backend)
		$(meson_use screencast remote_desktop)
		$(meson_use udev)
		$(meson_use input_devices_wacom libwacom)
		-Dpango_ft2=true
		-Dstartup_notification=true
		-Dsm=true
		$(meson_use introspection)
		$(meson_use test cogl_tests)
		$(meson_use test clutter_tests)
		# Wayland/Core tests cause issues. They attempt to access video hardware
		# and leave /tmp/.X#-lock files behind.
		-Dcore_tests=false # wayland
		$(meson_use test tests)
		$(meson_use sysprof profiler)
		-Dinstalled_tests=false
		#verbose
	)

	if use wayland; then
		emesonargs+=(
			$(meson_use video_cards_nvidia egl_device)
			$(meson_use video_cards_nvidia wayland_eglstream)
		)
	fi

	meson_src_configure
}

src_test() {
	gnome2_environment_reset # Avoid dconf that looks at XDG_DATA_DIRS, which can sandbox fail if flatpak is installed
	glib-compile-schemas "${BUILD_DIR}"/data
	GSETTINGS_SCHEMA_DIR="${BUILD_DIR}"/data virtx meson_src_test --no-suite flaky
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_schemas_update
}
