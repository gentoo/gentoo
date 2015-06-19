# Copyright 2006-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xoo/xoo-0.7.ebuild,v 1.4 2010/07/21 15:01:34 ssuominen Exp $

DESCRIPTION="A graphical wrapper around xnest"
HOMEPAGE="http://projects.o-hand.com/xoo"
SRC_URI="http://projects.o-hand.com/sources/xoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="gnome"

DEPEND="gnome? ( gnome-base/gconf )
	gnome-base/libglade
	x11-libs/libXtst
	x11-base/xorg-server"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Fix default Xnest binary path.
	sed -e "s:/usr/X11R6/bin/Xnest:$(type -P Xnest):" -i src/main.c || die
}

src_compile() {
	econf \
		$(use_enable gnome gconf)
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS Changelog NEWS README TODO
}
