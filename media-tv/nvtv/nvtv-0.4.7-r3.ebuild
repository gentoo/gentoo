# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

IUSE="X gtk"

DESCRIPTION="TV-Out for NVidia cards"
HOMEPAGE="https://sourceforge.net/projects/nv-tv-out/"
SRC_URI="mirror://sourceforge/nv-tv-out/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-apps/pciutils[-zlib]
	gtk? ( x11-libs/gtk+:2 )
	X? ( x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXxf86vm )"

DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

PATCHES=( "${FILESDIR}/respect-cflags.patch" )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with gtk) $(use_with X x)
}

src_install() {
	dobin src/nvtv
	dosbin src/nvtvd
	dodoc ANNOUNCE BUGS FAQ README doc/*.txt doc/USAGE
	newinitd "${FILESDIR}"/nvtv.start nvtv
}
