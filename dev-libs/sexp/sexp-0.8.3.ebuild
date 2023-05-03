# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="S-expressions parser and generator library in C++"
HOMEPAGE="https://github.com/rnpgp/sexp"
SRC_URI="https://github.com/rnpgp/sexp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="cli static-libs test"

BDEPEND="virtual/pkgconfig
	test? ( dev-cpp/gtest )"

RESTRICT="!test? ( test )"

PATCHES=( "${FILESDIR}"/sexp-0.8.3-fix-missing-cstdint-include.patch )

src_configure() {
	local mycmakeargs=(
		-DDOWNLOAD_GTEST=off

		-DWITH_COVERAGE=off
		-DWITH_SANITIZERS=off
		-DWITH_SEXP_CLI=$(usex cli on off)
		-DWITH_SEXP_TESTS=$(usex test on off)
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	if ! use static-libs; then
		find "${D}" -name '*.a' -delete || die
	fi
}
