# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DEB_PR=16

DESCRIPTION="X11 Plotting Utility"
HOMEPAGE="https://www.isi.edu/nsnam/xgraph/"
SRC_URI="https://www.isi.edu/nsnam/dist/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PR}.debian.tar.gz"

LICENSE="xgraph"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~sparc ~x86"
IUSE="examples"

RDEPEND="x11-libs/libSM
	x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=( "${WORKDIR}"/debian/patches/debian-changes )

src_prepare() {
	default
	rm -f configure.in Makefile.in || die
	eautoreconf
}

src_install() {
	default
	dodoc "${WORKDIR}"/debian/changelog
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	dodir /usr/share/man/man1

	mv "${ED}"/usr/share/man/manm/xgraph.man \
	   "${ED}"/usr/share/man/man1/xgraph.1 || die
	rm -r "${ED}"/usr/share/man/manm || die
}
