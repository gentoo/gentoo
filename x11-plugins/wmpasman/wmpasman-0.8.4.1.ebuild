# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Password storage/retrieval in a dockapp"
HOMEPAGE="http://sourceforge.net/projects/wmpasman/"
SRC_URI="mirror://sourceforge/wmpasman/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.4.1:2
	>=app-crypt/mhash-0.9.1
	>=app-crypt/mcrypt-2.6.4"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	virtual/pkgconfig
	>=x11-libs/libXpm-3.5.5"

src_prepare() {
	# Solves compile error about undefined exit - Bug 140857
	sed -i -e '/#include <stdio.h>/ { p ; s/stdio/stdlib/ }' wmgeneral/wmgeneral-gtk.c || die
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc BUGS ChangeLog README TODO WARNINGS
}
