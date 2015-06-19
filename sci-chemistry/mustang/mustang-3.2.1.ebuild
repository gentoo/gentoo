# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/mustang/mustang-3.2.1.ebuild,v 1.9 2012/04/29 10:36:13 jlec Exp $

EAPI=4

inherit eutils toolchain-funcs

MY_PN="MUSTANG"
SRC_P="${PN}_v${PV}"
MY_P="${MY_PN}_v${PV}"

DESCRIPTION="MUltiple STructural AligNment AlGorithm"
HOMEPAGE="http://www.csse.monash.edu.au/~karun/Site/mustang.html"
SRC_URI="http://www.csse.unimelb.edu.au/~arun/${PN}/${SRC_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.7.patch
}

src_compile() {
	emake \
		CPP=$(tc-getCXX) \
		CPPFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_test() {
	./bin/${P} -f ./data/test/test_zf-CCHH || die
}

src_install() {
	newbin bin/${P} mustang
	doman man/${PN}.1
	dodoc README
}

pkg_postinst() {
	elog "If you use this program for an academic paper, please cite:"
	elog "Arun S. Konagurthu, James C. Whisstock, Peter J. Stuckey, and Arthur M. Lesk"
	elog "Proteins: Structure, Function, and Bioinformatics. 64(3):559-574, Aug. 2006"
}
