# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="automatic theorem prover for satisfiability modulo theories (SMT) problems"
HOMEPAGE="http://cvc4.cs.stanford.edu/web/"
SRC_URI="https://github.com/CVC4/CVC4/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cln proofs readline replay +statistics"

RDEPEND="dev-libs/antlr-c
	dev-java/antlr:3
	dev-libs/boost
	readline? ( sys-libs/readline:0= )
	cln? ( sci-libs/cln )
	!cln? ( dev-libs/gmp:= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/CVC4-${PV}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_configure() {
	CMAKE_MAKEFILE_GENERATOR=emake
	local mycmakeargs=(
		-DANTLR_BINARY=/usr/bin/antlr3
		-DENABLE_GPL=ON
		-DENABLE_OPTIMIZED=ON
		-DUSE_CLN="$(usex cln ON OFF)"
		-DUSE_READLINE="$(usex readline ON OFF)"
		-DENABLE_STATISTICS="$(usex statistics ON OFF)"
		-DENABLE_PROOFS="$(usex proofs ON OFF)"
		-DENABLE_REPLAY="$(usex replay ON OFF)"
	)
	cmake-utils_src_configure
}

src_test() {
	emake -C "${BUILD_DIR}" \
		examples \
		boilerplate \
		ouroborous \
		reset_assertions \
		sep_log_api \
		smt2_compliance \
		two_smt_engines \
		statistics
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	mv "${D}"/usr/{lib,$(get_libdir)}
}
