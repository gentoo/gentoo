# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="A frontend for gPhoto 2"
HOMEPAGE="http://gphoto.org/proj/gtkam"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86"
IUSE="gimp gnome nls"

RDEPEND="
	x11-libs/gtk+:2
	>=media-libs/libgphoto2-2.5.0
	>=media-libs/libexif-0.3.2
	media-libs/libexif-gtk
	gimp? ( >=media-gfx/gimp-2 )
	gnome? (
		>=gnome-base/libbonobo-2
		>=gnome-base/libgnomeui-2 )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	app-text/scrollkeeper
	nls? ( >=sys-devel/gettext-0.14.1 )
"

src_prepare() {
	# Fix .desktop validity, bug #271569
	epatch "${FILESDIR}/${PN}-0.1.18-desktop-validation.patch"

	# Fix underlinking, bug #496136
	epatch "${FILESDIR}/${PN}-0.2.0-underlinking.patch"

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_with gimp) \
		$(use_with gnome) \
		$(use_with gnome bonobo) \
		$(use_enable nls) \
		--with-rpmbuild=/bin/false
}

src_install() {
	gnome2_src_install
	rm -rf "${ED}"/usr/share/doc/gtkam || die "rm failed"
}
