# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_COMMIT="9e8c3df573015a26c84e113ba710ef3d57c8e777"

DESCRIPTION="Multi-purpose finite-state toolkit"
HOMEPAGE="https://fomafst.github.io/ https://github.com/mhulden/foma"
SRC_URI="https://github.com/mhulden/foma/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/foma-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0/0.10"
KEYWORDS="amd64 x86"

BDEPEND="app-alternatives/yacc
	app-alternatives/lex"
DEPEND="sys-libs/readline:=
	sys-libs/zlib"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${WORKDIR}/foma-${MY_COMMIT}/foma"

PATCHES=(
	"${FILESDIR}"/foma-0.10.0-gcc-13-fixes.patch
	"${FILESDIR}"/foma-0.10-0-fix-BOM_codes-initializer.patch
	"${FILESDIR}"/foma-0.10.0_p20220612-fix-incompatible-function-pointer-types.patch
)

src_test() {
	local -x PATH="${BUILD_DIR}:${PATH}"
	pushd foma/tests >/dev/null || die
	./run.sh || die
	popd >/dev/null || die
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.a' -delete || die
}
