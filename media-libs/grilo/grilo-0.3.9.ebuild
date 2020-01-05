# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_6,3_7} )
VALA_USE_DEPEND="vapigen"

inherit gnome.org meson python-any-r1 vala xdg

DESCRIPTION="A framework for easy media discovery and browsing"
HOMEPAGE="https://wiki.gnome.org/Projects/Grilo"

LICENSE="LGPL-2.1+"
SLOT="0.3/0" # subslot is libgrilo-0.3 soname suffix
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86"

IUSE="gtk gtk-doc +introspection +network +playlist test vala"
REQUIRED_USE="vala? ( introspection )"
RESTRICT="!test? ( test )"

# oauth could be optional if meson is patched - used for flickr oauth in grilo-test-ui tool
RDEPEND="
	>=dev-libs/glib-2.44:2
	dev-libs/libxml2:2
	network? ( >=net-libs/libsoup-2.41.3:2.4[introspection?] )
	playlist? ( >=dev-libs/totem-pl-parser-3.4.1 )
	introspection? ( >=dev-libs/gobject-introspection-1.54:= )

	gtk? (
		net-libs/liboauth
		>=x11-libs/gtk+-3.14:3 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	gtk-doc? (
		>=dev-util/gtk-doc-1.10
		app-text/docbook-xml-dtd:4.3 )
	${PYTHON_DEPS}
	test? ( sys-apps/dbus )
	vala? ( $(vala_depend) )
"

PATCHES=(
	# Will be fixed in 0.3.11
	# https://gitlab.gnome.org/GNOME/grilo/commit/60d135ef64f16671bb0ab4079ecbc59bdc32cbc7
	"${FILESDIR}"/${PN}-0.3.9-totem-pl-parser.patch
)

src_prepare() {
	sed -i -e "s:'GETTEXT_PACKAGE', meson.project_name():'GETTEXT_PACKAGE', 'grilo-${SLOT%/*}':" meson.build || die
	sed -i -e "s:meson.project_name():'grilo-${SLOT%/*}':" po/meson.build || die
	sed -i -e "s:'grilo':'grilo-${SLOT%/*}':" doc/grilo/meson.build || die

	# Drop explicit unversioned vapigen check
	sed -i -e "/vapigen.*=.*find_program/d" meson.build || die

	# Don't build examples; they get embedded in gtk-doc, thus we don't install the sources with USE=examples either
	sed -i -e "/subdir('examples')/d" meson.build || die

	xdg_src_prepare
	use vala && vala_src_prepare
}

src_configure() {
	local emesonargs=(
		$(meson_use network enable-grl-net)
		$(meson_use playlist enable-grl-pls)
		$(meson_use gtk-doc enable-gtk-doc)
		$(meson_use introspection enable-introspection)
		$(meson_use gtk enable-test-ui)
		$(meson_use vala enable-vala)
	)
	meson_src_configure
}

src_test() {
	dbus-run-session meson test -C "${BUILD_DIR}" || die
}
