# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/jwasm/jwasm-2.10-r1.ebuild,v 1.1 2013/05/16 09:31:44 slyfox Exp $

EAPI=5

inherit eutils toolchain-funcs versionator

# 2.10 -> 210s
MY_PN=JWasm
MY_PV="$(delete_version_separator 1)s"
MY_P="${MY_PN}${MY_PV}"

DESCRIPTION="MASM-compatible TASM-similar assembler (fork of Wasm)"
HOMEPAGE="http://www.japheth.de/JWasm.html"
SRC_URI="http://www.japheth.de/Download/${MY_PN}/${MY_P}.zip"
LICENSE="Watcom-1.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc-4.8-fwdecl.patch
	epatch "${FILESDIR}"/${P}-types-test.patch
	epatch "${FILESDIR}"/${P}-uint_32-on-amd64.patch
	# don't strip binary
	sed -i GccUnix.mak -e 's/ -s / /g' || die
}

src_compile() {
	emake -f GccUnix.mak CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin GccUnixR/jwasm
	dodoc *.txt Doc/*.txt
}
