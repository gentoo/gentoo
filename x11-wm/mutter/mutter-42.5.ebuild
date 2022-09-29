# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
inherit gnome.org gnome2-utils meson python-any-r1 udev xdg

DESCRIPTION="GNOME compositing window manager based on Clutter"
HOMEPAGE="https://gitlab.gnome.org/GNOME/mutter/"

LICENSE="GPL-2+"
SLOT="0/$(($(ver_cut 1) - 32))" # 0/libmutter_api_version - ONLY gnome-shell (or anything using mutter-clutter-<api_version>.pc) should use the subslot

IUSE="doc elogind gnome input_devices_wacom +introspection screencast sysprof systemd test udev wayland video_cards_nvidia"
# native backend requires gles3 for hybrid graphics blitting support, udev and a logind provider
REQUIRED_USE="
	wayland? ( ^^ ( elogind systemd ) udev )
	test? ( wayland )"
RESTRICT="!test? ( test )"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

# gnome-settings-daemon is build checked, but used at runtime only for org.gnome.settings-daemon.peripherals.keyboard gschema
# xorg-server is needed at build and runtime with USE=wayland for Xwayland
# v3.32.2 has many excessive or unused *_req variables declared, thus currently the dep order ignores those and goes via dependency() call order
DEPEND="
	>=x11-libs/libX11-1.7.0
	>=media-libs/graphene-1.10.2[introspection?]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/pango-1.46[introspection?]
	>=dev-libs/fribidi-1.0.0
	>=x11-libs/cairo-1.14[X]
	>=gnome-base/gsettings-desktop-schemas-42.0[introspection?]
	>=dev-libs/glib-2.69.0:2
	gnome-base/gnome-settings-daemon
	>=dev-libs/json-glib-0.12.0[introspection?]
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
	>=dev-libs/atk-2.5.3[introspection?]
	>=media-libs/libcanberra-0.26
	sys-apps/dbus
	gnome? ( gnome-base/gnome-desktop:3= )
	media-libs/mesa[X(+),egl(+)]
	sysprof? ( >=dev-util/sysprof-capture-3.40.1:4 )
	systemd? ( sys-apps/systemd )
	wayland? (
		>=dev-libs/wayland-protocols-1.21
		>=dev-libs/wayland-1.18.0
		x11-libs/libdrm
		>=media-libs/mesa-17.3[egl(+),gbm(+),wayland,gles2]
		>=dev-libs/libinput-1.18.0:=
		elogind? ( sys-auth/elogind )
		x11-base/xwayland
		video_cards_nvidia? ( gui-libs/egl-wayland )
	)
	udev? ( >=dev-libs/libgudev-232
		>=virtual/libudev-232-r1:=
	)
	x11-libs/libSM
	input_devices_wacom? ( >=dev-libs/libwacom-0.13:= )
	>=x11-libs/startup-notification-0.7
	screencast? ( >=media-video/pipewire-0.3.21:= )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
	doc? ( >=dev-util/gi-docgen-2021.1 )
"
RDEPEND="${DEPEND}
	gnome-extra/zenity

	!<gui-libs/gtk-4.6.4:4
	!<x11-libs/gtk+-3.24.34:3
"
DEPEND="${DEPEND}
	x11-base/xorg-proto
	sysprof? ( >=dev-util/sysprof-common-3.38.0 )
"
BDEPEND="
	dev-util/wayland-scanner
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/python-dbusmock[${PYTHON_USEDEP}]
		')
		app-text/docbook-xml-dtd:4.5
		x11-misc/xvfb-run
	)
	wayland? (
		>=sys-kernel/linux-headers-4.4
		x11-libs/libxcvt
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-42.0-Disable-anonymous-file-test.patch
	"${FILESDIR}"/${PN}-42.4-backend-native-Don-t-warn-on-EACCES-if-headless.patch
)

python_check_deps() {
	if use test; then
		python_has_version "dev-python/python-dbusmock[${PYTHON_USEDEP}]"
	fi
}

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
		$(meson_use systemd)
		$(meson_use wayland native_backend)
		$(meson_use screencast remote_desktop)
		-Dlibgnome_desktop=true
		$(meson_use udev)
		-Dudev_dir=$(get_udevdir)
		$(meson_use input_devices_wacom libwacom)
		-Dpango_ft2=true
		-Dstartup_notification=true
		-Dsm=true
		$(meson_use introspection)
		$(meson_use doc docs)
		$(meson_use test cogl_tests)
		$(meson_use wayland core_tests) # core tests require wayland; overall -Dtests option is honored on top, so no extra conditional needed
		-Dnative_tests=false
		$(meson_use test clutter_tests)
		$(meson_use test tests)
		-Dkvm_tests=false
		-Dtty_tests=false
		$(meson_use sysprof profiler)
		-Dinstalled_tests=false
		#verbose # Let upstream choose default for verbose mode
		#xwayland_path
		# TODO: relies on default settings, but in Gentoo we might have some more packages we want to give Xgrab access (mostly virtual managers and remote desktops)
		#xwayland_grab_default_access_rules
	)

	if use wayland && use video_cards_nvidia; then
		emesonargs+=(
			-Degl_device=true
			-Dwayland_eglstream=true
		)
	else
		emesonargs+=(
			-Degl_device=false
			-Dwayland_eglstream=false
		)
	fi

	meson_src_configure
}

src_test() {
	gnome2_environment_reset # Avoid dconf that looks at XDG_DATA_DIRS, which can sandbox fail if flatpak is installed
	glib-compile-schemas "${BUILD_DIR}"/data
	GSETTINGS_SCHEMA_DIR="${BUILD_DIR}"/data meson_src_test --setup=CI
}

pkg_postinst() {
	use udev && udev_reload
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	use udev && udev_reload
	xdg_pkg_postrm
	gnome2_schemas_update
}
