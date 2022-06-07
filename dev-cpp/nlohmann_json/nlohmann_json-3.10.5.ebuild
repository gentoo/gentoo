# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#DOCS_BUILDER="mkdocs"
# Needs unpackaged plantuml-markdown too
# ... but plantuml (Python bindings anyway) need network access to generate bits at runtime.
#DOCS_DEPEND="dev-python/mkdocs-material-extensions dev-python/mkdocs-minify-plugin"
#DOCS_DIR="doc/mkdocs"
inherit cmake

# Check https://github.com/nlohmann/json/blob/develop/cmake/download_test_data.cmake to find test archive version
TEST_VERSION="3.0.0"
DESCRIPTION="JSON for Modern C++"
HOMEPAGE="https://github.com/nlohmann/json https://nlohmann.github.io/json/"
SRC_URI="
	https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/nlohmann/json_test_data/archive/v${TEST_VERSION}.tar.gz -> ${PN}-testdata-${TEST_VERSION}.tar.gz )"
S="${WORKDIR}/json-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 ~riscv x86"
IUSE="test"
# Need to report failing tests upstream
# Tests only just added, large test suite, majority pass
RESTRICT="test"

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
