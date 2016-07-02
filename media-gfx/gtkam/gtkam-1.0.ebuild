# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils gnome2

DESCRIPTION="A frontend for gPhoto 2"
HOMEPAGE="http://gphoto.org/proj/gtkam"
SRC_URI="mirror://sourceforge/gphoto/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="gimp nls"

RDEPEND="
	x11-libs/gtk+:2
	>=media-libs/libgphoto2-2.5.0
	>=media-libs/libexif-0.3.2
	media-libs/libexif-gtk
	gimp? ( >=media-gfx/gimp-2 )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.14.1 )
"

PATCHES=(
	# Fix .desktop validity, bug #271569
	"${FILESDIR}/${PN}-0.1.18-desktop-validation.patch"
)

src_configure() {
	gnome2_src_configure \
		--without-bonobo \
		--without-gnome \
		$(use_with gimp) \
		$(use_enable nls) \
		--with-rpmbuild=/bin/false
}

src_install() {
	gnome2_src_install
	rm -rf "${ED}"/usr/share/doc/gtkam || die "rm failed"
}
