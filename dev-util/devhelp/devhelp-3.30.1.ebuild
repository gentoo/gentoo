# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
# gedit-3.8 is python3 only, this also per:
# https://bugzilla.redhat.com/show_bug.cgi?id=979450
PYTHON_COMPAT=( python3_6 )

inherit gnome.org gnome2-utils meson python-single-r1 xdg

DESCRIPTION="An API documentation browser for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Devhelp"

LICENSE="GPL-3+"
SLOT="0/3-6" # subslot = 3-(libdevhelp-3 soname version)
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="gedit gtk-doc +introspection"
REQUIRED_USE="gedit? ( ${PYTHON_REQUIRED_USE} )"

COMMON_DEPEND="
	>=dev-libs/glib-2.56:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	>=net-libs/webkit-gtk-2.20:4[introspection?]
	>=gui-libs/amtk-5.0:5
	gnome-base/gsettings-desktop-schemas
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )
"
RDEPEND="${COMMON_DEPEND}
	gedit? (
		${PYTHON_DEPS}
		app-editors/gedit[introspection,python,${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}] )
"
# libxml2 required for glib-compile-resources
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-util/glib-utils
	dev-util/itstool
	gtk-doc? (
		>=dev-util/gtk-doc-1.25
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PV}-optional-introspection.patch
	"${FILESDIR}"/${PV}-optional-gedit.patch
)

pkg_setup() {
	use gedit && python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dflatpak_build=false
		$(meson_use gedit gedit_plugin)
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	use gedit && python_optimize "${ED%/}"/usr/$(get_libdir)/gedit/plugins
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
