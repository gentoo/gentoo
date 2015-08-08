# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils multilib

DESCRIPTION="A GTK+/libglade/GNOME language binding for the librep Lisp environment"
HOMEPAGE="http://sawfish.wikia.com/wiki/Main_Page"
SRC_URI="http://download.tuxfamily.org/librep/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="gtk-2.0"
KEYWORDS="alpha amd64 ia64 ppc ~ppc64 sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-libs/librep-0.90.5
	>=dev-libs/glib-2.6:2
	>=x11-libs/gtk+-2.24.0:2
	>=x11-libs/gdk-pixbuf-2.23:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	app-arch/xz-utils"

#src_prepare() {
	# Fix undefined symbol problems like bug #367623
	# http://listengine.tuxfamily.org/lists.tuxfamily.org/sawfish/2011/09/msg00026.html
	# TODO: Doesn't apply, if some people still get the failure, try to push a bit upstream
	#epatch "${FILESDIR}/${PN}-0.90.7-implicit-def-new.patch"
#}

src_configure() {
	econf \
		--libdir=/usr/$(get_libdir) \
		--disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -exec rm -f {} + || die "la file removal failed"
	dodoc AUTHORS ChangeLog README* TODO
}
