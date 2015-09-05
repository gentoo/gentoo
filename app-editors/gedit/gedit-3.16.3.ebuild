# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{3,4} )
VALA_MIN_API_VERSION="0.26"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome2 multilib python-r1 vala virtualx

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="+introspection +python spell vala"
# python-single-r1 would request disabling PYTHON_TARGETS on libpeas
# we need to fix that
REQUIRED_USE="
	python? ( introspection )
	python? ( ^^ ( $(python_gen_useflags '*') ) )
"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux"

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.40:2[dbus]
	>=x11-libs/gtk+-3.16:3[introspection?]
	>=x11-libs/gtksourceview-3.16:3.0[introspection?]
	>=dev-libs/libpeas-1.7.0[gtk]

	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	x11-libs/libX11

	net-libs/libsoup:2.4

	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	python? (
		${PYTHON_DEPS}
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
		dev-libs/libpeas[${PYTHON_USEDEP}] )
	spell? (
		>=app-text/enchant-1.2:=
		>=app-text/iso-codes-0.35 )
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/gnome-icon-theme-symbolic
"
DEPEND="${COMMON_DEPEND}
	${vala_depend}
	app-text/docbook-xml-dtd:4.1.2
	>=app-text/scrollkeeper-0.3.11
	dev-libs/libxml2:2
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"
# yelp-tools, gnome-common needed to eautoreconf

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS BUGS ChangeLog MAINTAINERS NEWS README"

	gnome2_src_configure \
		--disable-deprecations \
		--enable-updater \
		--enable-gvfs-metadata \
		$(use_enable introspection) \
		$(use_enable spell) \
		$(use_enable python) \
		$(use_enable vala)
}

src_test() {
	# FIXME: this should be handled at eclass level
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	unset DBUS_SESSION_BUS_ADDRESS
	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}

src_install() {
	local args=()
	# manually set pyoverridesdir due to bug #524018 and AM_PATH_PYTHON limitations
	use python && args+=( pyoverridesdir="$(python_get_sitedir)/gi/overrides" )

	gnome2_src_install "${args[@]}"
}
