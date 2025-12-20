# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN="MUSTANG"
SRC_P="${PN}_v${PV}"
MY_P="${MY_PN}_v${PV}"

DESCRIPTION="MUltiple STructural AligNment AlGorithm"
HOMEPAGE="http://www.csse.monash.edu.au/~karun/Site/mustang.html"
SRC_URI="http://www.csse.monash.edu.au/~karun/${PN}/${PN}_v${PV}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~x86"

PATCHES=( "${FILESDIR}"/${PN}-3.2.1-gcc-4.7.patch )

src_prepare() {
	default
	sed -e 's:3.2.1:3.2.2:g' -i Makefile || die
}

src_compile() {
	emake \
		CPP="$(tc-getCXX)" \
		CPPFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_test() {
	./bin/${P} -f ./data/test/test_zf-CCHH || die
}

src_install() {
	newbin bin/${P} ${PN}
	doman man/${PN}.1
	dodoc README
}

pkg_postinst() {
	elog "If you use this program for an academic paper, please cite:"
	elog "Arun S. Konagurthu, James C. Whisstock, Peter J. Stuckey, and Arthur M. Lesk"
	elog "Proteins: Structure, Function, and Bioinformatics. 64(3):559-574, Aug. 2006"
}
