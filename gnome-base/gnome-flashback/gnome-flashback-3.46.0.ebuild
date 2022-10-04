# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2 toolchain-funcs

DESCRIPTION="GNOME Flashback session"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-flashback/"

LICENSE="GPL-3+"
SLOT="0"
IUSE="elogind systemd"
REQUIRED_USE="^^ ( elogind systemd )"
KEYWORDS="~amd64 ~riscv"

RDEPEND="
	>=x11-libs/gdk-pixbuf-2.32.2:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=gnome-base/gnome-desktop-43:3=
	>=gnome-base/gnome-panel-3.35.2
	>=media-libs/libcanberra-0.13[gtk3]
	>=dev-libs/glib-2.67.3:2
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
	net-wireless/gnome-bluetooth:3=
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
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
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
	# "PKG_CHECK_MODULES([DESKTOP/SCREENSAVER], ...)" blocks did not change; otherwise adjust
	# elogind conditional block below accordingly first.
	if ver_test ${PV} -ne 3.46.0; then
		die "Maintainer has not checked over packages MENU pkg-config deps for elogind support"
	fi

	if use elogind; then
		local pkgconfig="$(tc-getPKG_CONFIG)"
		myconf+=(
			DESKTOP_CFLAGS="$(${pkgconfig} --cflags glib-2.0 gio-2.0 gio-unix-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind x11)"
			DESKTOP_LIBS="$(${pkgconfig} --libs glib-2.0 gio-2.0 gio-unix-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind x11)"
			SCREENSAVER_CFLAGS="$(${pkgconfig} --cflags gdm gio-unix-2.0 glib-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind xxf86vm)"
			SCREENSAVER_LIBS="$(${pkgconfig} --libs gdm gio-unix-2.0 glib-2.0 gnome-desktop-3.0 gtk+-3.0 libelogind xxf86vm)"
		)
	fi

	gnome2_src_configure "${myconf[@]}"
}
