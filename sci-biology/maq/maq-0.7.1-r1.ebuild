# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

DESCRIPTION="Mapping and Assembly with Qualities - mapping Solexa and SOLiD reads to reference sequences"
HOMEPAGE="http://maq.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	mirror://sourceforge/${PN}/calib-36.dat.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-flags.patch \
		"${FILESDIR}"/${P}-bfr-overfl.patch \
		"${FILESDIR}"/${P}-gcc-4.7.patch
	sed \
		-e '/ext_CFLAGS/s:-m64::g' \
		-i configure* || die
	eautoreconf
}

src_install() {
	default
	insinto /usr/share/maq
	doins "${WORKDIR}"/*.dat
	doman maq.1
	dodoc ${PN}.pdf
}
