# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eapi7-ver gnome2

DESCRIPTION="The GNOME Flashback Panel"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-panel/"

LICENSE="GPL-2+ FDL-1.1 LGPL-2.1+"
SLOT="0"
IUSE="eds elogind systemd"
REQUIRED_USE="^^ ( elogind systemd )"
KEYWORDS="~amd64"

RDEPEND="
	>=gnome-base/gnome-desktop-2.91.0:3=
	>=x11-libs/gdk-pixbuf-2.26.0:2
	>=x11-libs/pango-1.15.4
	>=dev-libs/glib-2.45.3:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=x11-libs/libwnck-3.4.6:3
	>=gnome-base/gnome-menus-3.7.90:3
	eds? ( >=gnome-extra/evolution-data-server-3.5.3:= )
	elogind? ( >=sys-auth/elogind-230 )
	systemd? ( >=sys-apps/systemd-230:= )
	>=x11-libs/cairo-1.0.0[X,glib]
	>=dev-libs/libgweather-3.28.0:2=
	>=gnome-base/dconf-0.13.4
	>=x11-libs/libXrandr-1.3.0
	gnome-base/gdm
	x11-libs/libX11
	sys-auth/polkit
	x11-libs/libXi
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1.25
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	x11-base/xorg-proto
" # yelp-tools and autoconf-archive for eautoreconf

src_configure() {
	local myconf=(
		--disable-static
		$(use_enable eds)
	)

	# Below elogind MENU_* pkg-config calls need to match up with what upstream has
	# each version (libsystemd replaced with libelogind). Explicit per-version die
	# to force a manual recheck. Only update the explicit version if the
	# "PKG_CHECK_MODULES([MENU], ...)" block did not change; otherwise adjust
	# elogind conditional block below accordingly first.
	if ver_test ${PV} -ne 3.32.0; then
		die "Maintainer has not checked over packages MENU pkg-config deps for elogind support"
	fi

	if use elogind; then
		myconf+=(
			MENU_CFLAGS=`pkg-config --cflags gdm gio-unix-2.0 gtk+-3.0 libgnome-menu-3.0 libelogind 2>/dev/null`
			MENU_LIBS=`pkg-config --libs gdm gio-unix-2.0 gtk+-3.0 libgnome-menu-3.0 libelogind 2>/dev/null`
		)
	fi

	gnome2_src_configure "${myconf[@]}"
}
