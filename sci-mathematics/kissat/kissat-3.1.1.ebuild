# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Keep-it-simple and clean bare metal SAT solver written in C"
HOMEPAGE="http://fmv.jku.at/kissat/
	https://github.com/arminbiere/kissat/"
SRC_URI="https://github.com/arminbiere/${PN}/archive/rel-${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-rel-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!>=x11-terms/kitty-0.27"

src_configure() {
	local myopts=(
		CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}"
		--kitten
		--statistics
	)
	sh ./configure "${myopts[@]}" || die
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	dolib.a build/libkissat.a
	exeinto /usr/bin/
	doexe build/{kissat,kitten}
	dodoc CONTRIBUTING NEWS.md README.md
}
