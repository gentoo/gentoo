# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit gnome.org gnome2-utils meson python-single-r1 vala xdg

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="+python gtk-doc"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc x86"

DEPEND="
	>=dev-libs/glib-2.70:2
	>=x11-libs/gtk+-3.22.0:3[introspection]
	>=gui-libs/amtk-5.6:=
	>=gui-libs/tepl-6.4:=
	>=dev-libs/libpeas-1.14.1[gtk]
	>=dev-libs/gobject-introspection-1.54:=
	>=app-text/gspell-0.2.5:0=
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pycairo[${PYTHON_USEDEP}]
			>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
			dev-libs/libpeas[python,${PYTHON_SINGLE_USEDEP}]
		')
	)

	>=x11-libs/gtksourceview-4.0.2:4[introspection,vala]
"
RDEPEND="${DEPEND}
	x11-themes/adwaita-icon-theme
	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs
"
BDEPEND="
	$(vala_depend)
	app-text/docbook-xml-dtd:4.1.2
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1 )
	dev-util/itstool
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
		-Duser_documentation=true

	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use python; then
		python_optimize
		python_optimize "${ED}/usr/$(get_libdir)/gedit/plugins/"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
