# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/fampp2/fampp2-6.0.1.ebuild,v 1.1 2010/08/21 16:49:09 vapier Exp $

EAPI="2"

DESCRIPTION="C++ wrapper for fam"
HOMEPAGE="https://sourceforge.net/projects/fampp/"
SRC_URI="mirror://sourceforge/fampp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/fam
	dev-libs/STLport
	dev-libs/ferrisloki
	>=dev-libs/libsigc++-2.0.0
	=dev-libs/glib-2*
	=x11-libs/gtk+-2*"

src_prepare() {
	sed -ri \
		-e '/^C(XX)?FLAGS/s:-O0 -g::' \
		-e '/^LDFLAGS/s:-Wl,-O1 -Wl,--hash-style=both::' \
		configure
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog NEWS README TODO
}
