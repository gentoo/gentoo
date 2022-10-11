# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Non-intrusive utility for estimation of available bandwidth of Internet paths"
HOMEPAGE="https://www.cc.gatech.edu/fac/constantinos.dovrolis/bw-est/pathload.html"
SRC_URI="https://dev.gentoo.org/~jsmolic/distfiles/${P}.tar.gz"
S="${WORKDIR}/${P/-/_}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${P}-make.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_configure() {
	tc-export CC
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	default
}

src_install() {
	dobin ${PN}_snd ${PN}_rcv
	dodoc CHANGELOG CHANGES README
}
