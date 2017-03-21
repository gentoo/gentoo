# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qmake-utils

DESCRIPTION="Generative art image evolver"
HOMEPAGE="https://sourceforge.net/projects/evolvotron/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

PATCHES=( "${FILESDIR}"/${P}-gcc6.patch )

DOCS=( BUGS NEWS README TODO USAGE )
HTML_DOCS=( evolvotron.html )

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
	einstalldocs
}
