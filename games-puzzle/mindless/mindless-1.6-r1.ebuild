# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop readme.gentoo-r1

ORANAME="OracleAll_050523.txt"
DESCRIPTION="Play trading card games (Magic: the Gathering etc.) against other people"
HOMEPAGE="http://mindless.sourceforge.net/"
SRC_URI="mirror://sourceforge/mindless/${P}.tar.gz
	http://www.wizards.com/dci/oracle/${ORANAME}
	http://mindless.sourceforge.net/images/logo.png -> ${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror" # for the card database

RDEPEND="
	x11-libs/gtk+:2
	media-fonts/font-schumacher-misc
"
DEPEND="${RDEPEND}
	gnome-base/librsvg:2
	virtual/pkgconfig
"

DATAFILE="/usr/share/${PN}/${ORANAME}"
DOC_CONTENTS="
	The first time you start ${PN} you need to tell it where to find
	the text database of cards.  This file has been installed at:
	${DATAFILE}
"

src_unpack() {
	unpack "${P}.tar.gz"
	cp "${DISTDIR}/${ORANAME}" "${WORKDIR}" || die "cp failed"
}

src_prepare() {
	default
	sed -i \
		-e '/^CC=/d' \
		-e '/^CFLAGS=/d' \
		Makefile \
		|| die 'sed failed'
}

src_install() {
	dobin mindless
	insinto "/usr/share/${PN}"
	doins "${WORKDIR}/${ORANAME}"
	einstalldocs
	readme.gentoo_create_doc
	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Mindless Automaton"
}

pkg_postinst() {
	readme.gentoo_print_elog
}
