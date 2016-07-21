# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit multilib toolchain-funcs

DESCRIPTION="a sound mixer and CD player dockapp"
HOMEPAGE="http://wmrack.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

src_prepare() {
	sed -i -e 's:gcc:$(CC):' "${S}"/Makefile.in
	sed -i -e 's:$(OBJECTS) -o:$(OBJECTS) $(LDFLAGS) -o:' "${S}"/Makefile.in
}

src_install() {
	emake LIBDIR="${D}/usr/$(get_libdir)/WMRack" \
		MANDIR="${D}/usr/share/man" BINDIR="${D}/usr/bin" \
		install

	dodoc CHANGES README TODO
}
