# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Synthesize Petri nets into asynchronous circuits"
HOMEPAGE="http://www.lsi.upc.edu/~jordicf/petrify/"
SRC_URI="http://www.lsi.upc.edu/~jordicf/petrify/distrib/${P}-linux.tgz"
S="${WORKDIR}"/${PN}

LICENSE="Old-MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="media-gfx/graphviz"

RESTRICT="strip"

QA_PREBUILT="opt/petrify/petrify"

src_install() {
	exeinto /opt/petrify
	doexe bin/petrify lib/petrify.lib
	dosym petrify /opt/petrify/draw_astg
	dosym petrify /opt/petrify/write_sg

	dodoc -r doc/.
	doman man/man1/*

	dodir /etc/env.d
	newenvd - 00petrify <<- _EOF_
		PATH="${EPREFIX}/opt/petrify"
	_EOF_
}
