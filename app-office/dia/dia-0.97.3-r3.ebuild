# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GNOME2_EAUTORECONF="yes"
inherit gnome2

DESCRIPTION="Diagram/flowchart creation program"
HOMEPAGE="https://wiki.gnome.org/Apps/Dia"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
# the doc USE flag doesn't seem to do anything without docbook2html
# cairo support is preferred as explained by upstream at:
# https://bugzilla.gnome.org/show_bug.cgi?id=729668#c6
IUSE="+cairo doc"

RDEPEND="
	>=dev-libs/glib-2:2
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/popt
	>=media-libs/freetype-2
	>=media-libs/libart_lgpl-2
	media-libs/libpng:=
	sys-libs/zlib
	x11-libs/gtk+:2
	x11-libs/pango
	cairo? ( x11-libs/cairo )
	doc? (
		app-text/docbook-xml-dtd:4.5
		app-text/docbook-xsl-stylesheets
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	virtual/pkgconfig
	doc? ( dev-libs/libxslt )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.97.0-gnome-doc.patch #159381 , upstream #470812 #558690
	"${FILESDIR}"/${PN}-0.97.2-underlinking.patch #420685, upstream #678761
	"${FILESDIR}"/${PN}-0.97.3-freetype_pkgconfig.patch #654814, upstream https://gitlab.gnome.org/GNOME/dia/merge_requests/1
	"${FILESDIR}"/${PN}-0.97.3-slibtool.patch
	"${FILESDIR}"/${PN}-0.97.3-configure-clang16.patch
	"${FILESDIR}"/${PN}-0.97.3-c99.patch
)

src_prepare() {
	if ! use doc; then
		# Skip man generation
		sed -i -e '/if HAVE_DB2MAN/,/endif/d' doc/*/Makefile.am || die
	fi

	# Fix naming conflict on Darwin/OSX, upstream bug #723869
	sed -i -e 's/isspecial/char_isspecial/' objects/GRAFCET/boolequation.c || die

	# Upstream bug #737254
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.in || die

	# Upstream bug #737255
	sed -i -e "/localedir/d" configure.in || die

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
		--without-python \
		--without-swig \
		--without-hardbooks
}

src_install() {
	gnome2_src_install
	dodoc KNOWN_BUGS RELEASE-PROCESS

	# Install second desktop file for integrated mode (bug #415495, upstream #588208)
	sed -e 's|^Exec=dia|Exec=dia --integrated|' \
			-e '/^Name/ s|$| (integrated mode)|' \
			"${ED}"/usr/share/applications/dia.desktop \
			> "${ED}"/usr/share/applications/dia-integrated.desktop || die
}
