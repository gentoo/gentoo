# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Curses-based interpreter and dev tools for TADS 2 and TADS 3 text adventures"
HOMEPAGE="http://www.tads.org/frobtads.htm"
SRC_URI="https://github.com/realnc/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="TADS2 TADS3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +tads2compiler +tads3compiler"

RESTRICT="!tads3compiler? ( test )"

RDEPEND="
	net-misc/curl
	sys-libs/ncurses:0=
"
DEPEND="${RDEPEND}"

DOCS=( doc/{AUTHORS,BUGS,ChangeLog.old,NEWS,README,SRC_GUIDELINES,THANKS} )

src_configure() {
	local mycmakeargs=(
		-DENABLE_T2_COMPILER=$(usex tads2compiler)
		-DENABLE_T2_RUNTIME_CHECKS=$(usex debug)
		-DENABLE_T3_COMPILER=$(usex tads3compiler)
		-DENABLE_T3_DEBUG=$(usex debug)
	)
	cmake_src_configure
}

src_test() {
	cmake_build sample
	"${BUILD_DIR}"/frob -i plain -p "${BUILD_DIR}"/samples/sample.t3 <<- END_FROB_TEST
		save
		testsave.sav
		restore
		testsave.sav
	END_FROB_TEST
	[[ $? -eq 0 ]] || die "Failed to run test game"
}
