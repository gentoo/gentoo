# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Synthesize Petri nets into asynchronous circuits"
HOMEPAGE="http://www.lsi.upc.edu/~jordicf/petrify/"
SRC_URI="http://www.lsi.upc.edu/~jordicf/petrify/distrib/petrify-4.2-linux.tgz"

LICENSE="Old-MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-gfx/graphviz"
DEPEND=""

RESTRICT="strip"

QA_PREBUILT="/opt/petrify/petrify"

S="${WORKDIR}"/${PN}

src_install () {
	exeinto /opt/petrify
	doexe bin/petrify lib/petrify.lib
	dosym petrify /opt/petrify/draw_astg
	dosym petrify /opt/petrify/write_sg

	dodoc doc/*
	doman man/man1/*

	dodir /etc/env.d
	echo "PATH=${EPREFIX}/opt/petrify" > "${ED}"/etc/env.d/00petrify
}
