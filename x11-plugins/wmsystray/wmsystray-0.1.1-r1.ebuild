# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Window Maker dock app that provides a system tray for GNOME/KDE applications"
HOMEPAGE="https://github.com/bbidulock/wmsystray"
SRC_URI="https://github.com/bbidulock/wmsystray/releases/download/${PV}/${P}.tar.bz2"

RDEPEND="x11-libs/libX11
	x11-libs/libXpm"
DEPEND="${RDEPEND}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~sparc x86"

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
	"${FILESDIR}/${P}-gcc-3.4.patch"
	"${FILESDIR}/${P}-return-type.patch"
)

DOCS=( README HACKING AUTHORS )

src_prepare() {
	default
	# Fix parallel compilation
	sed -ie "s/make EXTRACFLAGS/make \${MAKEOPTS} EXTRACFLAGS/" Makefile || die

	# Honour Gentoo LDFLAGS, see bug #336296
	sed -ie "s/-o wmsystray/${LDFLAGS} -o wmsystray/" wmsystray/Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" EXTRACFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}/${PN}
	doman doc/${PN}.1
	domenu "${FILESDIR}/${PN}.desktop"
	einstalldocs
}
