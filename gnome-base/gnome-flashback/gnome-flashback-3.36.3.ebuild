# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="GNOME Flashback session"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-flashback/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="elogind systemd"
REQUIRED_USE="^^ ( elogind systemd )"
KEYWORDS="~amd64"

RDEPEND="
	>=x11-libs/gdk-pixbuf-2.32.2:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=gnome-base/gnome-desktop-3.12.0:3=
	>=gnome-base/gnome-panel-3.35.2
	>=media-libs/libcanberra-0.13[gtk3]
	>=dev-libs/glib-2.44.0:2
	>=gnome-base/gsettings-desktop-schemas-3.31.0
	>=sys-auth/polkit-0.97
	>=app-i18n/ibus-1.5.2
	>=sys-power/upower-0.99.0:=
	>=x11-libs/libXrandr-1.5.0
	>=x11-libs/libXxf86vm-1.1.4
	x11-libs/libxcb
	x11-libs/libX11
	gnome-base/gdm
	elogind? ( >=sys-auth/elogind-230 )
	systemd? ( >=sys-apps/systemd-230:= )
	net-wireless/gnome-bluetooth
	x11-libs/libXext
	>=x11-libs/libXi-1.6.0
	x11-libs/pango
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	x11-libs/libXfixes
	media-sound/pulseaudio[glib]
	sys-libs/pam
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	x11-base/xorg-proto
	virtual/pkgconfig
" # autoconf-archive for eautoreconf
RDEPEND="${RDEPEND}
	x11-wm/metacity
	gnome-base/gnome-panel
	gnome-base/gnome-settings-daemon
"

src_configure() {
	local myconf=(
		--disable-static
		--without-compiz-session
		$(use_enable systemd systemd-session)
	)

	# Below elogind DESKTOP_* and SCREENSAVER_* pkg-config calls need to match up with
	# what upstream has each version (libsystemd replaced with libelogind). Explicit
	# per-version die to force a manual recheck. Only update the explicit version if the
	# "PKG_CHECK_MODULES([MENU/SCREENSAVER], ...)" blocks did not change; otherwise adjust
	# elogind conditional block below accordingly first.
	if ver_test ${PV} -ne 3.36.3; then
		die "Maintainer has not checked over packages MENU pkg-config deps for elogind support"
	fi

	if use elogind; then
		myconf+=(
			DESKTOP_CFLAGS=`pkg-config --cflags glib-2.0 gio-2.0 gio-unix-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind x11 2>/dev/null`
			DESKTOP_LIBS=`pkg-config --libs glib-2.0 gio-2.0 gio-unix-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind x11 2>/dev/null`
			SCREENSAVER_CFLAGS=`pkg-config --cflags gdm gio-unix-2.0 glib-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind xxf86vm 2>/dev/null`
			SCREENSAVER_LIBS=`pkg-config --libs gdm gio-unix-2.0 glib-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind xxf86vm 2>/dev/null`
		)
	fi

	gnome2_src_configure "${myconf[@]}"
}
