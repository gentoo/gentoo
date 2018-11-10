# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils multilib

MYPN=Bonmin

DESCRIPTION="COIN-OR Basic Open-source Nonlinear Mixed INteger programming"
HOMEPAGE="https://projects.coin-or.org/Bonmin/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="CPL-1.0"
SLOT="0/4"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples glpk static-libs test"

RDEPEND="
	sci-libs/coinor-cbc:=
	sci-libs/coinor-clp:=
	sci-libs/ipopt:="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( virtual/latex-base )
	test? ( sci-libs/coinor-sample )"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_configure() {
	local myeconfargs=(
		--enable-dependency-linking
	)
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile all $(usex doc doc "")
}

src_test() {
	autotools-utils_src_test test
}

src_install() {
	autotools-utils_src_install
	# add missing include files needed from coinor-couenne and others
	insinto /usr/include/coin
	doins \
		src/Interfaces/BonCurvatureEstimator.hpp \
		src/Interfaces/BonExitCodes.hpp \
		src/Algorithms/QuadCuts/BonLinearCutsGenerator.hpp

	use doc && dodoc doc/BONMIN_UsersManual.pdf
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/*
	fi
}
