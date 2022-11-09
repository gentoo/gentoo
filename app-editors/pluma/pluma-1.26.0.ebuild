# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MATE_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{8..11} )
inherit mate python-single-r1 virtualx

DESCRIPTION="Pluma text editor for the MATE desktop"

LICENSE="FDL-1.1+ GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"
IUSE="+introspection spell test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=dev-libs/libpeas-1.2.0[gtk]
	>=dev-libs/libxml2-2.5:2
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3[introspection?]
	>=x11-libs/gtksourceview-4.0.2:4
	x11-libs/libICE
	x11-libs/libX11
	>=x11-libs/libSM-1.0
	x11-libs/pango
	introspection? ( >=dev-libs/gobject-introspection-0.9.3:= )
	spell? (
		>=app-text/enchant-1.6:=
		>=app-text/iso-codes-0.35
	)
	!!app-editors/mate-text-editor
"
RDEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	>=mate-base/mate-desktop-1.9[introspection?]
	virtual/libintl
"
DEPEND="${COMMON_DEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	app-text/yelp-tools
	dev-util/glib-utils
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=sys-devel/libtool-2.2.6:2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

MATE_FORCE_AUTORECONF=true

src_prepare() {
	# Test require gvfs sftp fs mounted and schema's installed. Skip this one.
	# https://github.com/mate-desktop/mate-text-editor/issues/33
	sed -e '/+= document-saver/d' -i tests/Makefile.am || die

	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		$(use_enable introspection) \
		$(use_enable spell) \
		$(use_enable test tests)
}

src_test() {
	# FIXME: This should be handled at eclass level.
	"${EPREFIX}/${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	unset DBUS_SESSION_BUS_ADDRESS
	local -x GSETTINGS_SCHEMA_DIR="${S}/data"
	virtx emake check
}
