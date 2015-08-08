# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{3,4} )
PYTHON_REQ_USE="xml"

inherit eutils gnome2 multilib python-r1

DESCRIPTION="Official plugins for gedit"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit/ShippedPlugins"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

IUSE_plugins="charmap git terminal zeitgeist"
IUSE="+python ${IUSE_plugins}"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
REQUIRED_USE="
	charmap? ( python )
	git? ( python )
	python? ( ^^ ( $(python_gen_useflags '*') ) )
	terminal? ( python )
	zeitgeist? ( python )
"

RDEPEND="
	>=app-editors/gedit-3.16[python?]
	>=dev-libs/glib-2.32:2
	>=dev-libs/libpeas-1.7.0[gtk,python?]
	>=x11-libs/gtk+-3.9:3
	>=x11-libs/gtksourceview-3.14:3.0
	python? (
		${PYTHON_DEPS}
		>=app-editors/gedit-3.16[introspection,${PYTHON_USEDEP}]
		dev-libs/libpeas[${PYTHON_USEDEP}]
		>=dev-python/dbus-python-0.82[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
		>=x11-libs/gtk+-3.9:3[introspection]
		>=x11-libs/gtksourceview-3.14:3.0[introspection]
		x11-libs/pango[introspection]
		x11-libs/gdk-pixbuf:2[introspection]
	)
	charmap? ( >=gnome-extra/gucharmap-3:2.90[introspection] )
	git? ( >=dev-libs/libgit2-glib-0.0.6 )
	terminal? ( x11-libs/vte:2.91[introspection] )
	zeitgeist? ( >=gnome-extra/zeitgeist-0.9.12[introspection] )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	sys-devel/gettext
	virtual/pkgconfig
"

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_configure() {
	gnome2_src_configure \
		$(use_enable python) \
		$(use_enable zeitgeist) \
		ITSTOOL=$(type -P true)
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
