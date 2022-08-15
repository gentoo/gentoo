# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VALA_MIN_API_VERSION="0.40"

inherit gnome.org gnome2-utils meson vala virtualx xdg

DESCRIPTION="A calculator application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Calculator"

LICENSE="GPL-3+"
SLOT="0"
IUSE="+introspection test"
KEYWORDS="amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"

# gtksourceview vapi definitions in dev-lang/vala itself are too old, and newer vala removes them
# altogether, thus we need them installed by gtksourceview[vala]
RDEPEND="
	>=dev-libs/glib-2.40.0:2
	dev-libs/libxml2:2
	>=net-libs/libsoup-2.42:2.4
	>=dev-libs/libgee-0.20.0:0.8
	dev-libs/mpc:=
	dev-libs/mpfr:0=
	>=gui-libs/gtk-4.4.1:4
	>=gui-libs/libadwaita-1.0.0:1
	>=gui-libs/gtksourceview-5.3.0:5
	introspection? ( >=dev-libs/gobject-introspection-1.58:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	net-libs/libsoup:2.4[vala]
	gui-libs/gtksourceview:5[vala]
	gui-libs/libhandy:1[vala]
"

src_prepare() {
	default
	vala_setup
	# Automagic dep on valadoc - don't bother for now
	sed -e '/subdir.*doc/d' -i meson.build || die
}

src_configure() {
	local emesonargs=(
		-Ddisable-ui=false
		#-Dvala-version # doesn't do anything in 3.34
		$(meson_use !introspection disable-introspection)
		$(meson_use test ui-tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
