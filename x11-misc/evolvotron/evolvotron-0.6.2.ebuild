# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
PYTHON_DEPEND="2:2.6"
inherit python qt4-r2

DESCRIPTION="Generative art image evolver"
HOMEPAGE="https://sourceforge.net/projects/evolvotron/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	dev-qt/qtgui:4
	dev-libs/boost
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	eqmake4 main.pro
}

src_compile() {
	./text_to_markup.py -html < USAGE > evolvotron.html
	./text_to_markup.py -qml -s < USAGE > libevolvotron/usage_text.h

	local etsubdir
	for etsubdir in \
		libfunction libevolvotron evolvotron evolvotron_render evolvotron_mutate
		do
		emake sub-${etsubdir}
	done
}

src_install() {
	for bin in ${PN}{,_mutate,_render}; do
		dobin ${bin}/${bin}
	done

	doman man/man1/*
	dodoc BUGS NEWS README TODO USAGE
	dohtml *.html
}
