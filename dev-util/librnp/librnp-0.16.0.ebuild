# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High performance C++ OpenPGP library"
HOMEPAGE="https://www.rnpgp.org/ https://github.com/rnpgp/rnp"
SRC_URI="https://github.com/rnpgp/rnp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="man test"

RDEPEND="app-arch/bzip2
	dev-libs/botan:2=
	dev-libs/json-c:=
	sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"
BDEPEND="man? ( dev-ruby/asciidoctor )"

RESTRICT="!test? ( test )"
S="${WORKDIR}/${P/*lib/}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test on off)

		-DCRYPTO_BACKEND=botan

		-DDOWNLOAD_GTEST=off
		-DDOWNLOAD_RUBYRNP=off

		-DENABLE_COVERAGE=off
		-DENABLE_DOC=$(usex man on off)
		-DENABLE_FUZZERS=off
		-DENABLE_SANITIZERS=off
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	ctest -j"${MAKEOPTS}" -R .* --output-on-failure || die
}
