# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="PHAT is a collection of GTK+ widgets geared toward pro-audio apps"
HOMEPAGE="http://phat.berlios.de"
SRC_URI="mirror://berlios/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="debug"

RDEPEND="x11-libs/gtk+:2
	gnome-base/libgnomecanvas"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -e "s:-Werror::g" -e "s:-O3:${CFLAGS}:g" \
		-i configure || die "sed failed"
}

src_configure() {
	econf \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO
}
