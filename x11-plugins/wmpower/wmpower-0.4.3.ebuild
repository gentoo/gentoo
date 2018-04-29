# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

DESCRIPTION="a dockapp to get/set power management status for laptops (APM, ACPI
and CPUfreq)"
HOMEPAGE="http://wmpower.sourceforge.net/"
SRC_URI="mirror://sourceforge/wmpower/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto"

src_compile() {
	# override wmpower self-calculated cflags
	econf MY_CFLAGS="${CFLAGS}" || die "Configuration failed"
	emake prefix="/usr/" || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc AUTHORS BUGS ChangeLog LEGGIMI NEWS README README.compal THANKS TODO
}
