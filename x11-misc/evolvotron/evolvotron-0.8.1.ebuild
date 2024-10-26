# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils # >=0.8.2 supports qt6

DESCRIPTION="Generative art image evolver"
HOMEPAGE="https://sourceforge.net/projects/evolvotron/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-libs/boost:=
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"

DOCS=( BUGS NEWS README TODO USAGE )
HTML_DOCS=( evolvotron.html )

src_configure() {
	eqmake5 main.pro
}

src_compile() {
	local etsubdir
	local targets=( libfunction libevolvotron evolvotron evolvotron_render evolvotron_mutate )

	for etsubdir in ${targets[@]}; do
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
