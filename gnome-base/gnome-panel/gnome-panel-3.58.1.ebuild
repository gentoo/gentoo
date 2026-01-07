# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2 toolchain-funcs

DESCRIPTION="The GNOME Flashback Panel"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-panel/"

LICENSE="GPL-2+ FDL-1.1 LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ~riscv"
IUSE="eds elogind systemd"
REQUIRED_USE="^^ ( elogind systemd )"

RDEPEND="
	>=gnome-base/gnome-desktop-3.53.3:3=
	>=x11-libs/gdk-pixbuf-2.26.0:2
	>=x11-libs/pango-1.15.4
	>=dev-libs/glib-2.67.1:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=x11-libs/libwnck-43.2:3
	>=gnome-base/gnome-menus-3.7.90:3
	>=gnome-base/gsettings-desktop-schemas-42.0
	eds? ( >=gnome-extra/evolution-data-server-3.46.0:= )
	elogind? ( >=sys-auth/elogind-230 )
	systemd? ( >=sys-apps/systemd-230:= )
	>=x11-libs/cairo-1.0.0[X,glib]
	>=dev-libs/libgweather-4.2.0:4=
	>=gnome-base/dconf-0.13.4
	>=x11-libs/libXrandr-1.3.0
	gnome-base/gdm
	x11-libs/libX11
	x11-libs/libXi
	sci-geosciences/geocode-glib:2
	sys-auth/polkit
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

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
	# DO NOT just change the version, look in configure.ac in which PKG_CHECK_MODULES-sections
	# libsystemd is used and check if there are new sections where it is used!
	if ver_test ${PV} -ne 3.58.1; then
		die "Maintainer has not checked over packages MENU pkg-config deps for elogind support"
	fi

	if use elogind; then
		local pkgconfig="$(tc-getPKG_CONFIG)"

		local action_modules="gio-unix-2.0 gtk+-3.0 libgnome-menu-3.0 libelogind x11"
		local launcher_modules="gio-unix-2.0 gtk+-3.0 libgnome-menu-3.0 libelogind"
		local menu_modules="gdm gio-unix-2.0 gtk+-3.0 libgnome-menu-3.0 libelogind"

		myconf+=(
			ACTION_BUTTON_CFLAGS="$(${pkgconfig} --cflags ${action_modules})"
			ACTION_BUTTON_LIBS="$(${pkgconfig} --libs ${action_modules})"
			LAUNCHER_CFLAGS="$(${pkgconfig} --cflags ${launcher_modules})"
			LAUNCHER_LIBS="$(${pkgconfig} --libs ${launcher_modules})"
			MENU_CFLAGS="$(${pkgconfig} --cflags ${menu_modules})"
			MENU_LIBS="$(${pkgconfig} --libs ${menu_modules})"
		)
	fi

	gnome2_src_configure "${myconf[@]}"
}
