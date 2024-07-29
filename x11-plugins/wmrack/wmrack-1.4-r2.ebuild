# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a sound mixer and CD player dockapp"
HOMEPAGE="https://wmrack.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

DOCS=( CHANGES README TODO )

PATCHES=( "${FILESDIR}"/${PV}-Fix-type-specifier-missing-and-undeclared-function-c.patch )

src_prepare() {
	default
	ln -s grey.style XPM/standart.style || die
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
