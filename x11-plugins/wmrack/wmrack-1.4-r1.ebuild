# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="a sound mixer and CD player dockapp"
HOMEPAGE="http://wmrack.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( CHANGES README TODO )

src_prepare() {
	default
	sed -i \
		-e 's:gcc:$(CC):' \
		-e 's:$(OBJECTS) -o:$(OBJECTS) $(LDFLAGS) -o:' "${S}"/Makefile.in || die
}

src_install() {
	emake LIBDIR="${D}/usr/$(get_libdir)/WMRack" \
		MANDIR="${D}/usr/share/man" BINDIR="${D}/usr/bin" \
		install
	einstalldocs
}
