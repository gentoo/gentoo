# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit eutils versionator gnome2

DESCRIPTION="Light weight WM designed for use on PDA computers"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${PN}/$(get_version_component_range 1-2)/${P}.tar.bz2"
SLOT="0"
LICENSE="GPL-2"

KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE="debug expat gnome session startup-notification xcomposite"

RDEPEND="
	>=x11-libs/libmatchbox-1.5
	expat? ( dev-libs/expat )
	gnome? ( gnome-base/gconf )
	startup-notification? ( x11-libs/startup-notification )
	session? ( x11-libs/libSM )
	xcomposite? (
		x11-libs/libXcomposite
		x11-libs/libXdamage )
"
DEPEND="${RDEPEND}"

src_prepare() {
	# Allows to build with USE=-png
	epatch "${FILESDIR}"/${PN}-1.0-use-nopng.patch
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
	 	--enable-keyboard \
		--enable-ping-protocol \
		--enable-xrm \
		$(use_enable debug) \
		$(use_enable session) \
		$(use_enable expat) \
		$(use_enable gnome gconf) \
		$(use_enable startup-notification) \
		$(use_enable xcomposite composite)
}
