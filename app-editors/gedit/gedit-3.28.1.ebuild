# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes" # plugins are dlopened
PYTHON_COMPAT=( python3_{5,6} )
VALA_MIN_API_VERSION="0.26"
VALA_USE_DEPEND="vapigen"

inherit eutils gnome2 multilib python-single-r1 vala virtualx

DESCRIPTION="A text editor for the GNOME desktop"
HOMEPAGE="https://wiki.gnome.org/Apps/Gedit"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"

IUSE="+introspection +python spell vala"
REQUIRED_USE="python? ( introspection ${PYTHON_REQUIRED_USE} )"

KEYWORDS="~alpha amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"

# X libs are not needed for OSX (aqua)
COMMON_DEPEND="
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/glib-2.44:2[dbus]
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	>=x11-libs/gtksourceview-3.22.0:3.0[introspection?]
	>=dev-libs/libpeas-1.14.1[gtk]

	gnome-base/gsettings-desktop-schemas
	gnome-base/gvfs

	x11-libs/libX11

	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	python? (
		${PYTHON_DEPS}
		dev-python/pycairo[${PYTHON_USEDEP}]
		>=dev-python/pygobject-3:3[cairo,${PYTHON_USEDEP}]
		dev-libs/libpeas[python,${PYTHON_USEDEP}] )
	spell? ( >=app-text/gspell-0.2.5:0= )
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	${vala_depend}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/glib-utils
	>=dev-util/gtk-doc-am-1
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	>=sys-devel/gettext-0.18
	virtual/pkgconfig
"
# yelp-tools, gnome-common needed to eautoreconf

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

	gnome2_src_configure \
		--disable-deprecations \
		--disable-updater \
		--enable-gvfs-metadata \
		$(use_enable introspection) \
		$(use_enable spell) \
		$(use_enable python) \
		$(use_enable vala)
}

src_test() {
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die
	GSETTINGS_SCHEMA_DIR="${S}/data" virtx emake check
}

src_install() {
	local args=()
	# manually set pyoverridesdir due to bug #524018 and AM_PATH_PYTHON limitations
	use python && args+=( pyoverridesdir="$(python_get_sitedir)/gi/overrides" )

	gnome2_src_install "${args[@]}"
}
