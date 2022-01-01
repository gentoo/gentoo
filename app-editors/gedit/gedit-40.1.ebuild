# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
VALA_MIN_API_VERSION="0.26"
VALA_USE_DEPEND="vapigen"

inherit gnome.org gnome2-utils meson python-single-r1 vala xdg

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="+python gtk-doc spell"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND="
	>=dev-libs/glib-2.64:2
	>=dev-libs/libpeas-1.14.1[gtk]
	>=dev-libs/gobject-introspection-1.54:=
	>=x11-libs/gtk+-3.22.0:3[introspection]
	>=x11-libs/gtksourceview-4.0.2:4[introspection]
	gui-libs/tepl:6

	spell? ( >=app-text/gspell-0.2.5:0= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pycairo[${PYTHON_USEDEP}]
			>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
			dev-libs/libpeas[python,${PYTHON_SINGLE_USEDEP}]
		')
	)
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
PATCHES=(
	# Don't force off overlay scrollbars for dubious reasons that GNOME designers heavily
	# disagree with; those wanting them off in general would set that globally for gtk
	"${FILESDIR}"/restore-overlay-scrollbars.patch
	# Make gspell and python optional
	"${FILESDIR}"/3.38-make-gspell-optional.patch
	"${FILESDIR}"/3.38-make-python-optional.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use python)
		$(meson_use gtk-doc gtk_doc)
		-Duser_documentation=true
		$(meson_feature spell)
	)
	meson_src_configure
}

# Only appdata and desktop file validation in v3.32.2
src_test() { :; }

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
