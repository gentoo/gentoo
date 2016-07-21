# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="Curses-based interpreter and development tools for TADS 2 and TADS 3 text adventures"
HOMEPAGE="http://www.tads.org/frobtads.htm"
SRC_URI="http://www.tads.org/frobtads/${P}.tar.gz"

LICENSE="TADS2 TADS3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug tads2compiler tads3compiler"

RESTRICT="!tads3compiler? ( test )"

RDEPEND="net-misc/curl
	sys-libs/ncurses:0"
DEPEND=${RDEPEND}

DOCS=( doc/{AUTHORS,BUGS,ChangeLog.old,NEWS,README,SRC_GUIDELINES,THANKS} )

src_configure() {
	append-cxxflags -fpermissive
	append-libs $(curl-config --libs)
	egamesconf \
		$(use_enable debug t3debug) \
		$(use_enable debug error-checking) \
		$(use_enable tads2compiler t2-compiler) \
		$(use_enable tads3compiler t3-compiler)
}

src_test() {
	emake -j1 sample
	./frob -i plain -p samples/sample.t3 <<- END_FROB_TEST
		save
		testsave.sav
		restore
		testsave.sav
	END_FROB_TEST
	[[ $? -eq 0 ]] || die "Failed to run test game"
}

src_install() {
	default
	prepgamesdirs
}
