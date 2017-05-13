# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2 virtualx

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="https://git.gnome.org/browse/mutter/"

LICENSE="GPL-2+"
SLOT="0"

IUSE="debug gles2 input_devices_wacom +introspection test udev wayland"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# libXi-1.7.4 or newer needed per:
# https://bugzilla.gnome.org/show_bug.cgi?id=738944
COMMON_DEPEND="
	>=dev-libs/atk-2.5.3
	>=x11-libs/gdk-pixbuf-2:2
	>=dev-libs/json-glib-0.12.0
	>=x11-libs/pango-1.30[introspection?]
	>=x11-libs/cairo-1.14[X]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	>=dev-libs/glib-2.49.0:2[dbus]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.21.4[introspection?]
	gnome-base/gnome-desktop:3=
	>sys-power/upower-0.99:=

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.4
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	>=x11-libs/libXfixes-3
	>=x11-libs/libXi-1.7.4
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.5
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbfile
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-misc/xkeyboard-config

	gnome-extra/zenity
	media-libs/mesa[egl]

	gles2? ( media-libs/mesa[gles2] )
	input_devices_wacom? ( >=dev-libs/libwacom-0.13 )
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	udev? ( virtual/libgudev:= )
	wayland? (
		>=dev-libs/libinput-1.4
		>=dev-libs/wayland-1.6.90
		>=dev-libs/wayland-protocols-1.7
		>=media-libs/mesa-10.3[egl,gbm,wayland]
		sys-apps/systemd
		virtual/libgudev:=
		>=virtual/libudev-136:=
		x11-base/xorg-server[wayland]
		x11-libs/libdrm:=
	)
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	test? ( app-text/docbook-xml-dtd:4.5 )
	wayland? ( >=sys-kernel/linux-headers-4.4 )
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

PATCHES=(
	# Important fixes from gnome-3-22 branch, mostly for wayland session
	"${FILESDIR}"/${PV}-wayland-crash-fix.patch # firefox wrongly using subsurfaces for popups occasional crash fix
	"${FILESDIR}"/${PV}-clutter-missing-null-terminator.patch # fixes potential crashes on armhf
	"${FILESDIR}"/${PV}-wayland-ensure-pending-geometry.patch # initial positioning fix for wayland for certain apps
	"${FILESDIR}"/${PV}-wayland-size-hints.patch # apply min/max size hints in more cases properly
	"${FILESDIR}"/${PV}-wayland-clipboard-fix.patch # Fixes utf8 clipboard with gtk+-3.22.13+
)

src_prepare() {
	# Disable building of noinst_PROGRAM for tests
	if ! use test; then
		sed -e '/^noinst_PROGRAMS/d' \
			-i cogl/tests/conform/Makefile.{am,in} || die
		sed -e '/noinst_PROGRAMS += testboxes/d' \
			-i src/Makefile-tests.am || die
		sed -e '/noinst_PROGRAMS/ s/testboxes$(EXEEXT)//' \
			-i src/Makefile.in || die
	fi

	gnome2_src_prepare

	# Leave the damn CFLAGS alone
	sed -e 's/$CFLAGS -g/$CFLAGS /' \
		-i clutter/configure || die
	sed -e 's/$CFLAGS -g -O0/$CFLAGS /' \
		-i cogl/configure || die
	sed -e 's/$CFLAGS -g -O/$CFLAGS /' \
		-i configure || die
}

src_configure() {
	# Prefer gl driver by default
	# GLX is forced by mutter but optional in clutter
	# xlib-egl-platform required by mutter x11 backend
	# native backend without wayland is useless
	gnome2_src_configure \
		--disable-static \
		--enable-compile-warnings=minimum \
		--enable-gl \
		--enable-glx \
		--enable-sm \
		--enable-startup-notification \
		--enable-verbose-mode \
		--enable-xlib-egl-platform \
		--with-default-driver=gl \
		--with-libcanberra \
		$(usex debug --enable-debug=yes "") \
		$(use_enable gles2)        \
		$(use_enable gles2 cogl-gles2) \
		$(use_enable introspection) \
		$(use_enable wayland) \
		$(use_enable wayland kms-egl-platform) \
		$(use_enable wayland native-backend) \
		$(use_enable wayland wayland-egl-server) \
		$(use_with input_devices_wacom libwacom) \
		$(use_with udev gudev)
}

src_test() {
	virtx emake check
}
