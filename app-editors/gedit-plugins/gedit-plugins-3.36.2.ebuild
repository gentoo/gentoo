# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="xml"
VALA_MIN_API_VERSION="0.28"

inherit gnome.org gnome2-utils meson python-single-r1 vala xdg

DESCRIPTION="Collection of extra plugins for the gedit Text Editor"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit/ShippedPlugins"

LICENSE="GPL-2+"
KEYWORDS="~amd64 x86"
SLOT="0"

IUSE="charmap git +python terminal vala"
REQUIRED_USE="
	charmap? ( python )
	git? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	terminal? ( python )
"

RDEPEND="
	>=dev-libs/libpeas-1.14.1[gtk]
	>=app-editors/gedit-3.36

	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.9:3
	>=x11-libs/gtksourceview-4.0.2:4

	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=app-editors/gedit-3.36[introspection,python,${PYTHON_SINGLE_USEDEP}]
			dev-libs/libpeas[python,${PYTHON_SINGLE_USEDEP}]
			>=dev-python/dbus-python-0.82[${PYTHON_MULTI_USEDEP}]
			dev-python/pycairo[${PYTHON_MULTI_USEDEP}]
			dev-python/pygobject:3[cairo,${PYTHON_MULTI_USEDEP}]
		')
		>=x11-libs/gtk+-3.9:3[introspection]
		>=x11-libs/gtksourceview-4.0.2:4[introspection]
		x11-libs/pango[introspection]
		x11-libs/gdk-pixbuf:2[introspection]
	)
	charmap? ( >=gnome-extra/gucharmap-3:2.90[introspection] )
	git? ( >=dev-libs/libgit2-glib-0.0.6[python] )
	terminal? ( >=x11-libs/vte-0.52:2.91[introspection] )
" # vte-0.52+ for feed_child API compatibility
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dplugin_bookmarks=true
		$(meson_use python plugin_bracketcompletion)
		$(meson_use charmap plugin_charmap)
		$(meson_use python plugin_codecomment)
		$(meson_use python plugin_colorpicker)
		$(meson_use python plugin_colorschemer)
		$(meson_use python plugin_commander)
		-Dplugin_drawspaces=true
		$(meson_use vala plugin_findinfiles)
		$(meson_use git plugin_git)
		$(meson_use python plugin_joinlines)
		$(meson_use python plugin_multiedit)
		$(meson_use python plugin_sessionsaver)
		$(meson_use python plugin_smartspaces)
		$(meson_use python plugin_synctex)
		$(meson_use terminal plugin_terminal)
		$(meson_use python plugin_textsize)
		$(meson_use python plugin_translate)
		-Dplugin_wordcompletion=true
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize "${ED}/usr/$(get_libdir)/gedit/plugins/"
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
