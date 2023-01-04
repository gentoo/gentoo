# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only C++ library for JSON Schema validation"
HOMEPAGE="https://github.com/tristanpenman/valijson"
SRC_URI="https://github.com/tristanpenman/valijson/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-Dvalijson_BUILD_TESTS=$(usex test)
	)

	if use test; then
		# Fix relative paths to test data
		sed -i -e "s:../tests/data/documents/:../${P}/tests/data/documents/:" tests/test_adapter_comparison.cpp || die
		sed -i -e "s:../tests/data:../${P}/tests/data:" tests/test_validation_errors.cpp || die
		sed -i -e "s:../thirdparty/:../${P}/thirdparty/:" -e "s:../doc/schema/:../${P}/doc/schema/:" tests/test_validator.cpp || die
	fi

	# -Werror is too aggressive due to false positives with gcc-12, see bug #866153
	sed -i -e 's/-Werror//g' ../${P}/CMakeLists.txt || die

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	./test_suite || die
}

src_install() {
	# there is no target for installing headers, so do it manually
	doheader -r include/*
}
