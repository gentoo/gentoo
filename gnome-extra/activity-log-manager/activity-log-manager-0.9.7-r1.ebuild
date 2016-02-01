# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GNOME2_LA_PUNT="yes"
VALA_MIN_API_VERSION="0.26" # Fails with 0.24, but works with 0.26 and older versions
WANT_AUTOMAKE=1.13

inherit autotools eutils gnome2 vala versionator

DESCRIPTION="GUI which lets you easily control what gets logged by Zeitgeist"
HOMEPAGE="https://launchpad.net/activity-log-manager/"
SRC_URI="https://launchpad.net/history-manager/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-libs/libgee:0
	dev-libs/glib:2
	gnome-extra/zeitgeist
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig
	dev-util/intltool
	sys-devel/gettext"

src_prepare() {
	DOCS="README NEWS INSTALL ChangeLog AUTHORS"

	rm src/${PN}.c || die

	epatch \
		"${FILESDIR}"/${PN}-0.9.0.1-gold.patch \
		"${FILESDIR}"/${P}-gtk-icon_size.patch \
		"${FILESDIR}"/${P}-ambiguous.patch
	sed \
		-e "/^almdocdir/s:=.*$:= \${prefix}/share/doc/${PF}:g" \
		-i Makefile.am || die
	vala_src_prepare
	eautoreconf
	gnome2_src_prepare
}
