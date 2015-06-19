# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/xgraph/xgraph-12.1-r3.ebuild,v 1.2 2014/02/12 20:11:29 ulm Exp $

EAPI=4

inherit eutils autotools

DEB_PR=16

DESCRIPTION="X11 Plotting Utility"
HOMEPAGE="http://www.isi.edu/nsnam/xgraph/"
SRC_URI="http://www.isi.edu/nsnam/dist/${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}-${DEB_PR}.debian.tar.gz"

LICENSE="xgraph"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="examples"
DEPEND="x11-libs/libSM
	x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/debian-changes
	rm configure.in Makefile.in
	eautoreconf
}

src_install() {
	default
	dodoc "${WORKDIR}"/debian/changelog
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
	dodir /usr/share/man/man1
	mv  "${ED}"/usr/share/man/manm/xgraph.man \
		"${ED}"/usr/share/man/man1/xgraph.1 || die
	rm -r "${ED}"/usr/share/man/manm || die
}
