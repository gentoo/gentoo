# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

# Make sure that test data are not newer than release;
# otherwise we will see "Found-But-No-Test" test failures!
MY_TESTDATA_COMMIT="c07f38fae1e67adc288c2d6679df5d3652017fbe"

DESCRIPTION="Open-source JPEG 2000 library"
HOMEPAGE="https://www.openjpeg.org"
SRC_URI="https://github.com/uclouvain/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/uclouvain/openjpeg-data/archive/${MY_TESTDATA_COMMIT}.tar.gz -> ${PN}-data_20170814.tar.gz )"

LICENSE="BSD-2"
SLOT="2/7" # based on SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"

RDEPEND="
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS.md CHANGELOG.md NEWS.md README.md THANKS.md )

PATCHES=(
	"${FILESDIR}/${P}-fix-disable-static-libs.patch" # bug 650322
	"${FILESDIR}/${P}-gnuinstalldirs.patch" # bug 667150
)

src_prepare() {
	if use test; then
		mv "${WORKDIR}"/openjpeg-data-${MY_TESTDATA_COMMIT} "${WORKDIR}"/data ||
			die "Failed to rename test data"
	fi

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_PKGCONFIG_FILES=ON	# always build pkgconfig files, bug #539834
		-DBUILD_TESTING="$(multilib_native_usex test)"
		-DBUILD_DOC=$(multilib_native_usex doc ON OFF)
		-DBUILD_CODEC=$(multilib_is_native_abi && echo ON || echo OFF)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)

	cmake-utils_src_configure
}

multilib_src_test() {
	if ! multilib_is_native_abi ; then
		elog "Cannot run tests for non-multilib abi."
		return 0
	fi

	local myctestargs=

	pushd "${BUILD_DIR}" > /dev/null || die
	[[ -e CTestTestfile.cmake ]] || die "Test suite not available! Check source!"

	[[ -n ${TEST_VERBOSE} ]] && myctestargs+=( --extra-verbose --output-on-failure )

	echo ctest "${myctestargs[@]}" "$@"
	if ctest "${myctestargs[@]}" "$@" ; then
		einfo "Tests succeeded."
		popd > /dev/null || die
		return 0
	else
		echo ""
		einfo "Note: Upstream is maintaining a list of known test failures."
		einfo "We will now compare our test results against this list and sort out any known failure."

		local KNOWN_FAILURES_LIST="${S}/tools/travis-ci/knownfailures-all.txt"
		local FAILEDTEST_LOG="${BUILD_DIR}/Testing/Temporary/LastTestsFailed.log"
		local FAILURES_LOG="${BUILD_DIR}/Testing/Temporary/failures.txt"
		local FAILEDTEST=
		local HAS_UNKNOWN_TEST_FAILURES=0
		if [[ -f "${KNOWN_FAILURES_LIST}" && -f "${FAILEDTEST_LOG}" ]]; then
			# Logic copied from $S/tools/travis-ci/run.sh

			echo ""

			awk -F: '{ print $2 }' "${FAILEDTEST_LOG}" > "${FAILURES_LOG}"
			while read FAILEDTEST; do
				# Common errors
				if grep -x "${FAILEDTEST}" "${S}/tools/travis-ci/knownfailures-all.txt" > /dev/null; then
					ewarn "Test '${FAILEDTEST}' is known to fail, ignoring ..."
					continue
				fi
				eerror "New/unknown test failure found: '${FAILEDTEST}'"
				HAS_UNKNOWN_TEST_FAILURES=1
			done < "${FAILURES_LOG}"

			if [[ ${HAS_UNKNOWN_TEST_FAILURES} -ne 0 ]]; then
				die "Test suite failed. New/unknown test failure(s) found!"
			else
				echo ""
				einfo "Test suite passed. No new/unknown test failure(s) found!"
			fi

			return 0
		fi
	fi
}
