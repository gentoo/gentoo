# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome.org gnome2-utils meson virtualx xdg

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="https://gitlab.gnome.org/GNOME/mutter/"
SRC_URI+=" https://dev.gentoo.org/~leio/distfiles/${PF}-patchset.tar.xz"

LICENSE="GPL-2+"
SLOT="0/7" # 0/libmutter_api_version - ONLY gnome-shell (or anything using mutter-clutter-<api_version>.pc) should use the subslot

IUSE="elogind input_devices_wacom +introspection screencast sysprof systemd test udev wayland"
# native backend requires gles3 for hybrid graphics blitting support, udev and a logind provider
REQUIRED_USE="
	wayland? ( ^^ ( elogind systemd ) udev )
	test? ( wayland )"
RESTRICT="!test? ( test )"

KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# gnome-settings-daemon is build checked, but used at runtime only for org.gnome.settings-daemon.peripherals.keyboard gschema
# xorg-server is needed at build and runtime with USE=wayland for Xwayland
# v3.32.2 has many excessive or unused *_req variables declared, thus currently the dep order ignores those and goes via dependency() call order
DEPEND="
	x11-libs/libX11
	>=media-libs/graphene-1.9.3[introspection?]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/pango-1.30[introspection?]
	>=dev-libs/fribidi-1.0.0
	>=x11-libs/cairo-1.14[X]
	>=gnome-base/gsettings-desktop-schemas-3.37.2[introspection?]
	>=dev-libs/glib-2.61.1:2
	gnome-base/gnome-settings-daemon
	>=dev-libs/json-glib-0.12.0[introspection?]
	gnome-base/gnome-desktop:3=
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
	x11-libs/libxcb
	x11-libs/libXinerama
	x11-libs/libXau
	x11-libs/libICE
	>=dev-libs/atk-2.5.3[introspection?]
	>=media-libs/libcanberra-0.26
	sys-apps/dbus
	media-libs/mesa[X(+),egl]
	sysprof? ( >=dev-util/sysprof-capture-3.38.0:4 )
	wayland? (
		>=dev-libs/wayland-protocols-1.19
		>=dev-libs/wayland-1.18.0
		x11-libs/libdrm:=
		>=media-libs/mesa-17.3[egl,gbm,wayland,gles2]
		>=dev-libs/libinput-1.7
		systemd? ( sys-apps/systemd )
		elogind? ( sys-auth/elogind )
		x11-base/xorg-server[wayland]
	)
	udev? ( >=dev-libs/libgudev-232:=
		>=virtual/libudev-232-r1:= )
	x11-libs/libSM
	input_devices_wacom? ( >=dev-libs/libwacom-0.13 )
	>=x11-libs/startup-notification-0.7
	screencast? ( >=media-video/pipewire-0.3.0:0/0.3 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${DEPEND}
	gnome-extra/zenity
"
DEPEND="${DEPEND}
	x11-base/xorg-proto
	sysprof? ( >=dev-util/sysprof-common-3.38.0 )
"
# wayland bdepend for wayland-scanner, xorg-server for cvt utility
BDEPEND="
	dev-libs/wayland
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( app-text/docbook-xml-dtd:4.5 )
	wayland? ( >=sys-kernel/linux-headers-4.4
		x11-base/xorg-server )
"

PATCHES=(
	# origin/gnome-3-38@d881fcdece608
	"${WORKDIR}"/patches
)

src_configure() {
	# TODO: Replicate debug vs release meson build type behaviour under our buildtype=plain
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
		-Degl_device=false # This should be dependent on wayland,video_drivers_nvidia, once eglstream support is there
		-Dwayland_eglstream=false # requires packages egl-wayland for wayland-eglstream-protocols.pc
		$(meson_use udev)
		$(meson_use input_devices_wacom libwacom)
		-Dpango_ft2=true
		-Dstartup_notification=true
		-Dsm=true
		$(meson_use introspection)
		$(meson_use test cogl_tests)
		$(meson_use wayland core_tests) # core tests require wayland; overall -Dtests option is honored on top, so no extra conditional needed
		$(meson_use test clutter_tests)
		$(meson_use test tests)
		$(meson_use sysprof profiler)
		-Dinstalled_tests=false
		#verbose # Let upstream choose default for verbose mode
		#xwayland_path
		# TODO: relies on default settings, but in Gentoo we might have some more packages we want to give Xgrab access (mostly virtual managers and remote desktops)
		#xwayland_grab_default_access_rules
	)
	meson_src_configure
}

src_test() {
	glib-compile-schemas "${BUILD_DIR}"/data
	GSETTINGS_SCHEMA_DIR="${BUILD_DIR}"/data virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
