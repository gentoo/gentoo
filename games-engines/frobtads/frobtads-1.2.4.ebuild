# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Curses-based interpreter and dev tools for TADS 2 and TADS 3 text adventures"
HOMEPAGE="http://www.tads.org/frobtads.htm"
SRC_URI="https://github.com/realnc/${PN}/releases/download/${PV}/${P}.tar.bz2"

LICENSE="TADS2 TADS3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug tads2compiler tads3compiler"

RESTRICT="!tads3compiler? ( test )"

RDEPEND="net-misc/curl
	sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

DOCS=( doc/{AUTHORS,BUGS,ChangeLog.old,NEWS,README,SRC_GUIDELINES,THANKS} )

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.4-tinfo.patch #602446
)

src_prepare() {
	default
	eautoreconf #602446
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug error-checking)
		$(use_enable debug t3debug)
		$(use_enable tads2compiler t2-compiler)
		$(use_enable tads3compiler t3-compiler)
	)
	econf "${myeconfargs[@]}"
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
