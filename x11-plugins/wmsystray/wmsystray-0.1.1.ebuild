# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit eutils

DESCRIPTION="Window Maker dock app that provides a system tray for GNOME/KDE applications"
HOMEPAGE="https://github.com/bbidulock/wmsystray"
SRC_URI="https://github.com/bbidulock/wmsystray/releases/download/${PV}/${P}.tar.bz2"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Let's honour Gentoo CFLAGS and use correct install program
	epatch "${FILESDIR}/${P}-Makefile.patch"

	# Fix for #61704, cannot compile with gcc 3.4.1:
	# it's a trivial change and does not affect other compilers...
	epatch "${FILESDIR}/${P}-gcc-3.4.patch"

	# Fix parallel compilation
	sed -ie "s/make EXTRACFLAGS/make \${MAKEOPTS} EXTRACFLAGS/" Makefile

	# Honour Gentoo LDFLAGS, see bug #336296
	sed -ie "s/-o wmsystray/${LDFLAGS} -o wmsystray/" wmsystray/Makefile
}

src_compile() {
	emake EXTRACFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	einstall || die "einstall failed"
	dodoc AUTHORS HACKING README || die

	domenu "${FILESDIR}/${PN}.desktop"
}
