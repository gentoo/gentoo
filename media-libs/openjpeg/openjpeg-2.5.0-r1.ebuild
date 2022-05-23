# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

# Make sure that test data are not newer than release;
# otherwise we will see "Found-But-No-Test" test failures!
#
# To update: Go to https://github.com/uclouvain/openjpeg-data and grab the hash
# of the latest possible commit whose commit date is older than the release
# date.
MY_TESTDATA_COMMIT="1f3d093030f9a0b43353ec6b48500f65786ff57a"

DESCRIPTION="Open-source JPEG 2000 library"
HOMEPAGE="https://www.openjpeg.org"
SRC_URI="https://github.com/uclouvain/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/uclouvain/openjpeg-data/archive/${MY_TESTDATA_COMMIT}.tar.gz -> ${PN}-data_20210926.tar.gz )"

LICENSE="BSD-2"
SLOT="2/7" # based on SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/tiff:0
	sys-libs/zlib:=
"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

DOCS=( AUTHORS.md CHANGELOG.md NEWS.md README.md THANKS.md )

PATCHES=(
	"${FILESDIR}/${PN}-2.5.0-gnuinstalldirs.patch" # bug #667150
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
	# bug #715130, bug #715422
	# https://github.com/uclouvain/openjpeg/issues/1017
	if multilib_is_native_abi && use test ; then
		append-cflags "-ffp-contract=off"
	fi

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

	if [[ -n ${TEST_VERBOSE} ]]; then
		myctestargs+=( --extra-verbose --output-on-failure )
	fi

	echo ctest "${myctestargs[@]}"
	if ctest "${myctestargs[@]}" ; then
		popd > /dev/null || die
		einfo "Tests succeeded."
		return 0
	fi

	local FAILEDTEST_LOG="${BUILD_DIR}/Testing/Temporary/LastTestsFailed.log"

	# Should never happen
	[[ -f "${FAILEDTEST_LOG}" ]] || die "Cannot analyze test failures: LastTestsFailed.log is missing!"

	elog
	elog "Note: Upstream maintains a list of known test failures."
	elog "We will now compare our test results against this list and remove any known failures."
	elog

	local KNOWN_FAILURES_LIST="${T}/known_failures_compiled.txt"
	cp "${S}/tools/travis-ci/knownfailures-all.txt" "${KNOWN_FAILURES_LIST}" || die

	local ARCH_SPECIFIC_FAILURES=
	if use amd64 ; then
		ARCH_SPECIFIC_FAILURES="$(find "${S}/tools/travis-ci/" -name 'knownfailures-*x86_64*.txt' -print0 | sort -z | tail -z -n 1 | tr -d '\0')"
	elif use x86 || use arm || use arm64; then
		ARCH_SPECIFIC_FAILURES="$(find "${S}/tools/travis-ci/" -name 'knownfailures-*i386*.txt' -print0 | sort -z | tail -z -n 1 | tr -d '\0')"
	fi

	if [[ -f "${ARCH_SPECIFIC_FAILURES}" ]]; then
		elog "Adding architecture specific failures (${ARCH_SPECIFIC_FAILURES}) to known failures list ..."
		elog
		<"${ARCH_SPECIFIC_FAILURES}" >> "${KNOWN_FAILURES_LIST}" || die
	fi

	# Logic copied from $S/tools/travis-ci/run.sh
	local FAILEDTEST=
	local HAS_UNKNOWN_TEST_FAILURES=0

	awk -F: '{ print $2 }' "${FAILEDTEST_LOG}" | while read FAILEDTEST; do
		# is this failure known?
		if grep -xq "${FAILEDTEST}" "${KNOWN_FAILURES_LIST}" ; then
			elog "Test '${FAILEDTEST}' is known to fail, ignoring ..."
		else
			eerror "New/unknown test failure found: '${FAILEDTEST}'"
			HAS_UNKNOWN_TEST_FAILURES=1
		fi
	done

	[[ ${HAS_UNKNOWN_TEST_FAILURES} -eq 0 ]] || die "Test suite failed. New/unknown test failure(s) found!"

	elog
	elog "Test suite passed. No new/unknown test failure(s) found!"

	popd > /dev/null || die
	return 0
}
