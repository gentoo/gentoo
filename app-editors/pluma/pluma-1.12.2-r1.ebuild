# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"

PYTHON_COMPAT=( python2_7 )

inherit mate multilib python-single-r1 virtualx

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Pluma text editor for the MATE desktop"
LICENSE="GPL-2"
SLOT="0"

IUSE="gtk3 python spell"

REQUIRED_USE="
	gtk3? ( !python )
	python? ( ${PYTHON_REQUIRED_USE} )"

# Tests require gvfs sftp fs mounted and schema's installed. Disable tests.
# https://github.com/mate-desktop/mate-text-editor/issues/33
RESTRICT="test"

RDEPEND="app-text/rarian:0
	dev-libs/atk:0
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.5:2
	>=mate-base/mate-desktop-1.9[gtk3(-)=]
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE:0
	x11-libs/libX11:0
	>=x11-libs/libSM-1.0
	x11-libs/pango:0
	virtual/libintl:0
	!gtk3? (
		>=x11-libs/gtk+-2.24:2
		>=x11-libs/gtksourceview-2.9.7:2.0
	)
	gtk3? (
		>=x11-libs/gtk+-3.0:3
		>=x11-libs/gtksourceview-2.9.7:3.0
	)
	spell? (
		>=app-text/enchant-1.2:0
		>=app-text/iso-codes-0.35:0
	)
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-2.15.4:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.12:2[${PYTHON_USEDEP}]
		>=dev-python/pygtksourceview-2.9.2:2
	)
	!!app-editors/mate-text-editor"

DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.1.2
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1:*
	>=sys-devel/libtool-2.2.6:2
	>=sys-devel/gettext-0.17:*
	virtual/pkgconfig:*"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable python) \
		$(use_enable spell)
}

src_test() {
	# FIXME: This should be handled at eclass level.
	"${EROOT}${GLIB_COMPILE_SCHEMAS}" --allow-any-name "${S}/data" || die

	unset DBUS_SESSION_BUS_ADDRESS

	GSETTINGS_SCHEMA_DIR="${S}/data" Xemake check
}
