# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix toolchain-funcs

MY_P="${PN}_${PV}"
DESCRIPTION="A Magnetic Scrolls Interpreter for playing a collection of old text adventures"
HOMEPAGE="https://www.dettus.net/dMagnetic/"
SRC_URI="https://www.dettus.net/${PN}/${MY_P}.tar.bz2"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~x86"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	hprefixify ${PN}.ini src/toplevel/${PN}.c
}

src_compile() {
	emake ${PN} \
		  CC="$(tc-getCC)" \
		  LINK="$(tc-getCC) ${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1 ${PN}ini.5
	dodoc README.txt

	insinto /etc
	doins ${PN}.ini
}
