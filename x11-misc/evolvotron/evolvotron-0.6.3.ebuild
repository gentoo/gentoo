# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit qt4-r2

DESCRIPTION="Generative art image evolver"
HOMEPAGE="http://sourceforge.net/projects/evolvotron/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-libs/boost
	dev-qt/qtgui:4
"
DEPEND="
	${DEPEND}
"

S=${WORKDIR}/${PN}

src_configure() {
	eqmake4 main.pro
}

src_compile() {
	local etsubdir
	for etsubdir in \
		libfunction libevolvotron evolvotron evolvotron_render evolvotron_mutate
		do
		emake sub-${etsubdir}
	done
}

src_install() {
	local bin
	for bin in ${PN}{,_mutate,_render}; do
		dobin ${bin}/${bin}
	done
	doman man/man1/*
	dodoc BUGS NEWS README TODO USAGE
	dohtml *.html
}
