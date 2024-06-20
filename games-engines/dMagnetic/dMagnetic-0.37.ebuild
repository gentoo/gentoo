# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit prefix toolchain-funcs

MY_P="${PN}_${PV}"
DESCRIPTION="A Magnetic Scrolls Interpreter for playing a collection of old text adventures"
HOMEPAGE="https://www.dettus.net/dMagnetic/"
SRC_URI="https://www.dettus.net/${PN}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k ~x86"

src_prepare() {
	default
	hprefixify src/toplevel/${PN}{,_helpscreens}.c
}

src_compile() {
	emake all \
		  CC="$(tc-getCC)" \
		  LINK="$(tc-getCC) ${LDFLAGS}"
}

src_test() {
	emake check \
		  SHA256_CMD=sha256sum
}

src_install() {
	dobin ${PN}
	doman ${PN}.6 ${PN}ini.5
	dodoc README.txt

	insinto /etc
	doins ${PN}.ini
}
