# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="a dockapp to get/set power management status for laptops (APM, ACPI
and CPUfreq)"
HOMEPAGE="https://wmpower.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/wmpower/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-ar.patch
	)

DOCS=( AUTHORS BUGS ChangeLog LEGGIMI NEWS README README.compal THANKS TODO )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# override wmpower self-calculated cflags
	econf MY_CFLAGS="${CFLAGS}"
}

src_compile() {
	emake prefix="/usr/"
}
