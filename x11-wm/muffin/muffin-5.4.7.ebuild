# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg-utils virtualx

DESCRIPTION="Compositing window manager forked from Mutter for use with Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/muffin"
SRC_URI="https://github.com/linuxmint/muffin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+ LGPL-2+ LGPL-2.1+ MIT SGI-B-2.0"
SLOT="0"
IUSE="input_devices_wacom +introspection screencast sysprof test udev"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

# Dependencies listed in meson order
COMDEPEND="
	x11-libs/libX11
	>=media-libs/graphene-1.9.3[introspection?]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	x11-libs/gdk-pixbuf:2[introspection?]
	>=x11-libs/pango-1.20.0[introspection?]
	>=x11-libs/cairo-1.10.0:=[X]
	>=dev-libs/fribidi-1.0.0
	>=dev-libs/glib-2.61.1:2
	>=dev-libs/json-glib-0.12.0[introspection?]
	>=gnome-extra/cinnamon-desktop-5.4:0=
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
	|| (
		>=app-accessibility/at-spi2-core-2.46.0:2[introspection?]
		>=dev-libs/atk-2.5.3[introspection?]
	)
	>=media-libs/libcanberra-0.26
	sys-apps/dbus
	media-libs/libglvnd[X]
	media-libs/mesa[X(+),egl(+)]
	x11-libs/libSM
	>=x11-libs/startup-notification-0.7:=

	input_devices_wacom? ( >=dev-libs/libwacom-0.13:= )
	introspection? ( >=dev-libs/gobject-introspection-1.41.3:= )
	screencast? ( >=media-video/pipewire-0.3.0:= )
	sysprof? ( >=dev-util/sysprof-capture-3.35.2:4 )
	udev? ( >=virtual/libudev-228:=
	        >=dev-libs/libgudev-232 )
"
RDEPEND="${COMDEPEND}
	gnome-extra/zenity
"
DEPEND="${COMDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	sys-devel/gettext
	virtual/pkgconfig
"

# Wayland is not supported upstream.
src_configure() {
	local emesonargs=(
		-Dopengl=true
		#opengl_libname
		#gles2_libname
		-Dgles2=false # wayland
		-Degl=true
		-Dglx=true
		$(meson_use screencast remote_desktop)
		$(meson_use udev)
		$(meson_use input_devices_wacom libwacom)
		-Dpango_ft2=true
		-Dstartup_notification=true
		-Dsm=true
		$(meson_use introspection)
		$(meson_use test cogl_tests)
		$(meson_use test clutter_tests)
		-Dcore_tests=false # wayland
		$(meson_use test tests)
		$(meson_use sysprof profiler)
		-Dinstalled_tests=false
		#verbose
	)

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
