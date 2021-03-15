# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="JSON for Modern C++"
HOMEPAGE="https://github.com/nlohmann/json https://nlohmann.github.io/json/"
SRC_URI="
	https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/nlohmann/json_test_data/archive/v3.0.0.tar.gz -> ${P}-testdata.tar.gz )"
S="${WORKDIR}/json-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86"
IUSE="doc test"
#RESTRICT="!test? ( test )"
# Need to report failing tests upstream
# Tests only just added, large test suite, majority pass
RESTRICT="test"

BDEPEND="doc? ( app-doc/doxygen )"

DOCS=( ChangeLog.md README.md )

src_configure() {
	# Tests are built by default so we can't group the test logic below
	local mycmakeargs=(
		-DJSON_MultipleHeaders=ON
		-DJSON_BuildTests=$(usex test)
	)

	# Define test data directory here to avoid unused var QA warning, bug #747826
	use test && mycmakeargs+=( -DJSON_TestDataDirectory="${S}"/json_test_data )

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		emake -C doc
		HTML_DOCS=( doc/html/. )
	fi
}

src_test() {
	cd "${BUILD_DIR}/test" || die

	# Skip certain tests needing git per upstream
	# https://github.com/nlohmann/json/issues/2189
	local myctestargs=(
		"-LE git_required"
	)

	cmake_src_test
}
