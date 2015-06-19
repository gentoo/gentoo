# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/dia/dia-0.97.3_pre20140417-r1.ebuild,v 1.5 2015/04/08 07:30:34 mgorny Exp $

EAPI=5
GCONF_DEBUG=yes
GNOME2_LA_PUNT=yes
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-single-r1 multilib

DESCRIPTION="Diagram/flowchart creation program"
HOMEPAGE="https://wiki.gnome.org/Apps/Dia"

SRC_URI="http://dev.gentoo.org/~pacho/gnome/${PN}-0.97.3_pre20140417.tar.xz"
S="${WORKDIR}/${PN}-0.97.2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
# the doc USE flag doesn't seem to do anything without docbook2html
# cairo support is preferred as explained by upstream at:
# https://bugzilla.gnome.org/show_bug.cgi?id=729668#c6
IUSE="+cairo doc python"

RDEPEND="
	>=dev-libs/glib-2:2
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/popt
	>=media-libs/freetype-2
	>=media-libs/libart_lgpl-2
	media-libs/libpng:0
	sys-libs/zlib
	x11-libs/gtk+:2
	x11-libs/pango
	cairo? ( x11-libs/cairo )
	doc? (
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets )
	python? (
		>=dev-python/pygtk-2
		${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-apps/sed
	virtual/pkgconfig
	doc? ( dev-libs/libxslt )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	DOCS="AUTHORS ChangeLog KNOWN_BUGS MAINTAINERS NEWS README RELEASE-PROCESS THANKS TODO"

	epatch "${FILESDIR}"/${PN}-0.97.0-gnome-doc.patch #159381 , upstream #470812 #558690
	epatch "${FILESDIR}"/${PN}-0.97.2-underlinking.patch #420685
	epatch "${FILESDIR}"/${PN}-0.97.2-disable-cairo.patch #509636
	epatch "${FILESDIR}"/${PN}-0.97.2-png-crash.patch #508566

	if use python; then
		python_fix_shebang .
		sed -i -e "s/\.so/$(get_libname)/" acinclude.m4 || die #298232
	fi

	if ! use doc; then
		# Skip man generation
		sed -i -e '/if HAVE_DB2MAN/,/endif/d' doc/*/Makefile.am || die
	fi

	# Fix naming conflict on Darwin/OSX, upstream bug #????
	sed -i -e 's/isspecial/char_isspecial/' objects/GRAFCET/boolequation.c || die

	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die

	sed -i -e "/localedir/d" configure.in || die

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# --exec-prefix makes Python look for modules in the Prefix
	# --enable-gnome only adds support for deprecated stuff, bug #442294
	# https://bugzilla.redhat.com/show_bug.cgi?id=996759
	gnome2_src_configure \
		--exec-prefix="${EPREFIX}/usr" \
		--disable-gnome \
		--disable-libemf \
		$(use_enable doc db2html) \
		$(use_with cairo) \
		$(use_with python) \
		--without-swig \
		--without-hardbooks
}

src_install() {
	gnome2_src_install

	# Install second desktop file for integrated mode (bug #415495)
	sed -e 's|^Exec=dia|Exec=dia --integrated|' \
			-e '/^Name/ s|$| (integrated mode)|' \
			"${ED}"/usr/share/applications/dia.desktop \
			> "${ED}"/usr/share/applications/dia-integrated.desktop || die
}
