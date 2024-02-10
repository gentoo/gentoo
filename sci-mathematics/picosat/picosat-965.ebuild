# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="SAT solver with proof and core support"
HOMEPAGE="http://fmv.jku.at/picosat/"
SRC_URI="http://fmv.jku.at/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~x86"
LICENSE="MIT"

PATCHES=( "${FILESDIR}"/${P}-makefile.in.patch )

src_configure() {
	CC="$(tc-getCC)" sh ./configure.sh --shared --trace || die
}

src_compile() {
	emake AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" \
		CFLAGS="${CFLAGS} ${LDFLAGS} -fPIC"
}

src_install() {
	exeinto /usr/bin
	doexe picomus picomcs picosat picogcnf

	insinto /usr/share
	newins VERSION picosat.version

	dolib.so libpicosat.so
	doheader picosat.h

	dodoc NEWS README
}
