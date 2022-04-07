# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib flag-o-matic

# Make sure that test data are not newer than release;
# otherwise we will see "Found-But-No-Test" test failures!
MY_TESTDATA_COMMIT="cd724fb1f93e6af41ebc68c4904f4bf2a4cd1e60"

DESCRIPTION="Open-source JPEG 2000 library"
HOMEPAGE="https://www.openjpeg.org"
SRC_URI="https://github.com/uclouvain/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/uclouvain/openjpeg-data/archive/${MY_TESTDATA_COMMIT}.tar.gz -> ${PN}-data_20201130.tar.gz )"

LICENSE="BSD-2"
SLOT="2/7" # based on SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS.md CHANGELOG.md NEWS.md README.md THANKS.md )

PATCHES=(
	"${FILESDIR}/${PN}-2.4.0-r1-gnuinstalldirs.patch" # bug 667150
	"${FILESDIR}/${PN}-2.4.0-r2-fix-segfault.patch" # bug 832007
)

src_prepare() {
	if use test; then
		mv "${WORKDIR}"/openjpeg-data-${MY_TESTDATA_COMMIT} "${WORKDIR}"/data ||
			die "Failed to rename test data"
	fi

	cmake_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_PKGCONFIG_FILES=ON # always build pkgconfig files, bug #539834
		-DBUILD_TESTING="$(multilib_native_usex test)"
		-DBUILD_DOC=$(multilib_native_usex doc ON OFF)
		-DBUILD_CODEC=$(multilib_is_native_abi && echo ON || echo OFF)
		-DBUILD_STATIC_LIBS=$(usex static-libs)
	)

	# Cheat a little bit and force disabling fixed point magic
	# The test suite is extremely fragile to small changes
	# bug 715130, bug 715422
	# https://github.com/uclouvain/openjpeg/issues/1017
	multilib_is_native_abi && use test && append-cflags "-ffp-contract=off"

	cmake_src_configure
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
		local FAILEDTEST_LOG="${BUILD_DIR}/Testing/Temporary/LastTestsFailed.log"

		if [[ ! -f "${FAILEDTEST_LOG}" ]] ; then
			# Should never happen
			die "Cannot analyze test failures: LastTestsFailed.log is missing!"
		fi

		echo ""
		einfo "Note: Upstream is maintaining a list of known test failures."
		einfo "We will now compare our test results against this list and sort out any known failure."

		local KNOWN_FAILURES_LIST="${T}/known_failures_compiled.txt"
		cat "${S}/tools/travis-ci/knownfailures-all.txt" > "${KNOWN_FAILURES_LIST}" || die

		local ARCH_SPECIFIC_FAILURES=
		if use amd64 ; then
			ARCH_SPECIFIC_FAILURES="$(find "${S}/tools/travis-ci/" -name 'knownfailures-*x86_64*.txt' -print0 | sort -z | tail -z -n 1 | tr -d '\0')"
		elif use x86 || use arm || use arm64; then
			ARCH_SPECIFIC_FAILURES="$(find "${S}/tools/travis-ci/" -name 'knownfailures-*i386*.txt' -print0 | sort -z | tail -z -n 1 | tr -d '\0')"
		fi

		if [[ -f "${ARCH_SPECIFIC_FAILURES}" ]] ; then
			einfo "Adding architecture specific failures (${ARCH_SPECIFIC_FAILURES}) to known failures list ..."
			cat "${ARCH_SPECIFIC_FAILURES}" >> "${KNOWN_FAILURES_LIST}" || die
		fi

		# Logic copied from $S/tools/travis-ci/run.sh
		local FAILEDTEST=
		local FAILURES_LOG="${BUILD_DIR}/Testing/Temporary/failures.txt"
		local HAS_UNKNOWN_TEST_FAILURES=0

		echo ""

		awk -F: '{ print $2 }' "${FAILEDTEST_LOG}" > "${FAILURES_LOG}"
		while read FAILEDTEST; do
			# is this failure known?
			if grep -x "${FAILEDTEST}" "${KNOWN_FAILURES_LIST}" > /dev/null; then
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
}
