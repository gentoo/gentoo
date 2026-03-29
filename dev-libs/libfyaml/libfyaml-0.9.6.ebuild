# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

LLVM_COMPAT=( {17..22} )

inherit cmake python-any-r1 llvm-r2

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pantoniou/${PN}"
else

	# See CMakeLists.txt for details
	TESTSUITEURL="https://github.com/yaml/yaml-test-suite"
	TESTSUITE_PN="yaml-test-suite"
	TESTSUITECHECKOUT="6e6c296ae9c9d2d5c4134b4b64d01b29ac19ff6f"
	TESTSUITE_P="${TESTSUITE_PN}-${TESTSUITECHECKOUT}"

	JSONTESTSUITEURL="https://github.com/nst/JSONTestSuite"
	JSONTESTSUITE_PN="JSONTestSuite"
	JSONTESTSUITECHECKOUT="d64aefb55228d9584d3e5b2433f720ea8fd00c82"
	JSONTESTSUITE_P="${JSONTESTSUITE_PN}-${JSONTESTSUITECHECKOUT}"

	TEST_PN="yaml-test-suite"
	TEST_PV="2022-01-17"
	TEST_P="${TEST_PN}-${TEST_PV}"

	SRC_URI="
		https://github.com/pantoniou/${PN}/releases/download/v${PV}/${P}.tar.gz
		test? (
			${TESTSUITEURL}/archive/${TESTSUITECHECKOUT}.tar.gz -> ${TESTSUITE_P}.tar.gz
			${JSONTESTSUITEURL}/archive/${JSONTESTSUITECHECKOUT}.tar.gz -> ${JSONTESTSUITE_P}.tar.gz
		)
		https://github.com/pantoniou/${PN}/commit/600c93bbff40b939d19de3776da97a7579758776.patch
			-> ${P}-0001-fix-crash-on-NULL-pointer.patch
		https://github.com/pantoniou/${PN}/commit/040e85d6176f093bb50af750cd0ea5a76e502d5d.patch
			-> ${P}-0002-fix-UB-treaming_alias_collection_state.patch
		https://github.com/pantoniou/${PN}/commit/1026d76850909dc9b1c5f95b8cd94e865a313fd5.patch
			-> ${P}-0003-fix-c11-atomics-detection.patch
		https://github.com/pantoniou/${PN}/commit/0982fcefc6a16d4c8cb5b06747d3fc8e630de3ae.patch
			-> ${P}-0004-fix-32bit-build.patch
		https://github.com/pantoniou/${PN}/commit/ac7cc3f3442dae8b30276c929b0c833970d72937.patch
			-> ${P}-0005-folded-scalars.patch
		https://github.com/pantoniou/${PN}/commit/3fbc353d9018735140bf24e93ae35cedcea7eb62.patch
			-> ${P}-0006-docutils.error_reporting-workaround.patch
		https://github.com/pantoniou/${PN}/commit/b372618fa681a51d82fa44fb5a2959504de5e6d2.patch
			-> ${P}-0007-canned-man.patch
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="A high-performance YAML 1.2 and JSON parser/emitter with zero-copy operation"
HOMEPAGE="https://github.com/pantoniou/libfyaml"

LICENSE="MIT"
SLOT="0"
IUSE="clang doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	clang? (
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}=
			llvm-core/llvm:${LLVM_SLOT}=
		')
	)
	doc? (
		${PYTHON_DEPS}
		dev-python/sphinx
		dev-python/docutils
		dev-python/jinja2
		dev-python/pygments
	)
	test? (
		app-shells/bash
		app-misc/jq
		dev-libs/check
	)
"

DOCS=( AUTHORS CHANGELOG.md README.md )

PATCHES=(
	# utf8: Guard against NULL pointer in fy_utf8_split_posix
	"${DISTDIR}/${P}-0001-fix-crash-on-NULL-pointer.patch"
	# Fix UB in treaming_alias_collection_state
	"${DISTDIR}/${P}-0002-fix-UB-treaming_alias_collection_state.patch"
	# Fix C11 atomics detection and buggy macros for C++ compatibility
	"${DISTDIR}/${P}-0003-fix-c11-atomics-detection.patch"
	# Fix 32-bit build by removing stray parameter to fy_skip_size32()
	"${DISTDIR}/${P}-0004-fix-32bit-build.patch"
	# Fix folded scalars emit spurious trailing blank line in original mode
	"${DISTDIR}/${P}-0005-folded-scalars.patch"
	# Add BUILD_DOC switch
	"${FILESDIR}/${PN}-optional-doc.patch"
	# doc: workaround removed docutils.error_reporting
	"${DISTDIR}/${P}-0006-docutils.error_reporting-workaround.patch"
	# Add canned man and configuration switches
	"${FILESDIR}/${P}-canned-man.patch"
	)

src_prepare() {

	# Prepare tests without network access
	if use test; then
		ln -svf "${WORKDIR}/${TESTSUITE_P}" "${WORKDIR}/${P}/${TESTSUITE_P}" || die
		ln -svf "${WORKDIR}/${JSONTESTSUITE_P}" "${WORKDIR}/${P}/${JSONTESTSUITE_P}" || die
	fi

	use doc && python-any-r1_pkg_setup

	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DHAVE_CHECK=$(usex test)
		-DENABLE_ASAN:BOOL=OFF
		-DHAVE_LIBCLANG=$(usex clang)
		-DENABLE_NETWORK:BOOL=OFF
		-DBUILD_DOC:BOOL=$(usex doc)
	)

	cmake_src_configure
}
