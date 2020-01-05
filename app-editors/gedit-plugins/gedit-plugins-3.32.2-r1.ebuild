# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="xml"
VALA_MIN_API_VERSION="0.28"

inherit eutils gnome2 multilib python-single-r1 vala

DESCRIPTION="Official plugins for gedit"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit/ShippedPlugins"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE_plugins="charmap git terminal vala"
IUSE="+python ${IUSE_plugins}"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
REQUIRED_USE="
	charmap? ( python )
	git? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
	terminal? ( python )
"

RDEPEND="
	>=app-editors/gedit-3.16
	>=dev-libs/glib-2.32:2
	>=dev-libs/libpeas-1.7.0[gtk]
	>=x11-libs/gtk+-3.9:3
	>=x11-libs/gtksourceview-4.0.2:4
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			>=app-editors/gedit-3.16[introspection,python,${PYTHON_SINGLE_USEDEP}]
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
	git? ( >=dev-libs/libgit2-glib-0.0.6 )
	terminal? ( >=x11-libs/vte-0.52:2.91[introspection] )
	vala? ( $(vala_depend) )
" # vte-0.52+ for feed_child API compatibility
DEPEND="${RDEPEND}
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python-single-r1_pkg_setup
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable python) \
		$(use_enable vala)
}

src_install() {
	gnome2_src_install

	# FIXME: crazy !!!
	if use python; then
		find "${ED}"/usr/share/gedit -name "*.py*" -delete || die
		find "${ED}"/usr/share/gedit -type d -empty -delete || die
	fi

	# FIXME: upstream made this automagic...
	clean_plugin charmap
	clean_plugin git
	clean_plugin terminal
}

clean_plugin() {
	if use !${1} ; then
		rm -rf "${ED}"/usr/share/gedit/plugins/${1}*
		rm -rf "${ED}"/usr/$(get_libdir)/gedit/plugins/${1}*
	fi
}
