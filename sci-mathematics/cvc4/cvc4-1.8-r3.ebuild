# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR=emake
PYTHON_COMPAT=( python3_{9..11} )
inherit cmake python-any-r1

DESCRIPTION="Automatic theorem prover for satisfiability modulo theories (SMT) problems"
HOMEPAGE="https://cvc4.github.io/"
SRC_URI="https://github.com/CVC4/CVC4-archived/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cln proofs readline +statistics"

RDEPEND="dev-libs/antlr-c
	dev-java/antlr:3
	dev-libs/boost
	readline? ( sys-libs/readline:0= )
	cln? ( sci-libs/cln )
	!cln? ( dev-libs/gmp:= )"
DEPEND="${RDEPEND}"
BDEPEND="$(python_gen_any_dep '
		dev-python/tomli[${PYTHON_USEDEP}]
	')
"

S="${WORKDIR}"/${PN^^}-archived-${PV}

PATCHES=(
	"${FILESDIR}"/${P}-gentoo.patch
	"${FILESDIR}"/${P}-toml.patch
)

python_check_deps() {
	python_has_version "dev-python/tomli[${PYTHON_USEDEP}]"
}

src_configure() {
	local mycmakeargs=(
		-DANTLR_BINARY=/usr/bin/antlr3
		-DENABLE_GPL=ON
		-DUSE_CLN="$(usex cln ON OFF)"
		-DUSE_READLINE="$(usex readline ON OFF)"
		-DENABLE_STATISTICS="$(usex statistics ON OFF)"
		-DENABLE_PROOFS="$(usex proofs ON OFF)"
	)
	cmake_src_configure
}

src_test() {
	emake -C "${BUILD_DIR}" \
		systemtests
	cmake_src_test
}

src_install() {
	cmake_src_install
	mv "${D}"/usr/{lib,$(get_libdir)}
}
