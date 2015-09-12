# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"
VALA_USE_DEPEND="vapigen"
VALA_MIN_API_VERSION="0.16"

inherit autotools eutils gnome2 vala virtualx

DESCRIPTION="Manages, extracts and handles media art caches"
HOMEPAGE="https://github.com/GNOME/libmediaart"

LICENSE="LGPL-2.1+"
SLOT="2.0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="gtk +introspection qt4 qt5 vala"
REQUIRED_USE="
	?? ( gtk qt4 qt5 )
	vala? ( introspection )
"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	gtk? ( >=x11-libs/gdk-pixbuf-2.12:2 )
	introspection? ( >=dev-libs/gobject-introspection-1.30 )
	qt4? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtgui:5 )
"
DEPEND="${RDEPEND}
	>=dev-util/gtk-doc-am-1.8
	virtual/pkgconfig
	vala? ( $(vala_depend) )
"

src_prepare() {
	# Fix QT automagic selection, bug #523122
	epatch "${FILESDIR}"/${PN}-0.7.0-qt5.patch

	# Make doc parallel installable
	cd "${S}"/docs/reference/${PN}
	sed -e "s/\(DOC_MODULE.*=\).*/\1${PN}-${SLOT}/" \
		-e "s/\(DOC_MAIN_SGML_FILE.*=\).*/\1${PN}-docs-${SLOT}.sgml/" \
		-i Makefile.am Makefile.in || die
	sed -e "s/\(<book.*name=\"\)libmediaart/\1${PN}-${SLOT}/" \
		-i html/libmediaart.devhelp2 || die
	mv libmediaart-docs{,-${SLOT}}.sgml || die
	mv libmediaart-overrides{,-${SLOT}}.txt || die
	mv libmediaart-sections{,-${SLOT}}.txt || die
	mv html/libmediaart{,-${SLOT}}.devhelp2
	cd "${S}"

	eautoreconf

	use vala && vala_src_prepare
	gnome2_src_prepare
}

src_configure() {
	local myconf=""
	if use qt4 ; then
		myconf="${myconf} --enable-qt --with-qt-version=4"
	elif use qt5 ; then
		myconf="${myconf} --enable-qt --with-qt-version=5"
	else
		myconf="${myconf} --disable-qt"
	fi

	gnome2_src_configure \
		--enable-unit-tests \
		$(use_enable gtk gdkpixbuf) \
		$(use_enable introspection) \
		$(use_enable vala) \
		${myconf}
}

src_test() {
	dbus-launch Xemake check #513502
}
