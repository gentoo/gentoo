# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit qmake-utils

DESCRIPTION="Generative art image evolver"
HOMEPAGE="
	http://www.bottlenose.net/share/evolvotron/index.htm
	https://sourceforge.net/projects/evolvotron/
"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"

RDEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"

DOCS=(
	BUGS NEWS README TODO USAGE
)
HTML_DOCS=(
	evolvotron.html
)
S=${WORKDIR}/${PN}

src_configure() {
	eqmake5 main.pro
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
