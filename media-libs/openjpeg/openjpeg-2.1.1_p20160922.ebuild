# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit multilib cmake-multilib

# Make sure that test data are not newer than release;
# otherwise we will see "Found-But-No-Test" test failures!
MY_TESTDATA_COMMIT="cc09dc4e43850b725a2aaf6e1d58cbf45bc2322c"

MY_P_COMMIT="fac916f72a162483a4d6d804fd070fdf32f402ed"

DESCRIPTION="An open-source JPEG 2000 library"
HOMEPAGE="https://github.com/uclouvain/openjpeg"
SRC_URI="https://github.com/uclouvain/${PN}/archive/${MY_P_COMMIT}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/uclouvain/openjpeg-data/archive/${MY_TESTDATA_COMMIT}.tar.gz -> ${PN}-data_20160921.tar.gz )"

LICENSE="BSD-2"
SLOT="2/7" # based on SONAME
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"

RDEPEND="media-libs/lcms:2=
	media-libs/libpng:0=
	media-libs/tiff:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( AUTHORS.md CHANGELOG.md NEWS.md README.md THANKS.md )

S="${WORKDIR}/${PN}-${MY_P_COMMIT}"

src_prepare() {
	if use test; then
		mv "${WORKDIR}"/openjpeg-data-${MY_TESTDATA_COMMIT} "${WORKDIR}"/data || die "Failed to rename test data"
	fi

	default

	# Stop installing LICENSE file, and install CHANGES from DOCS instead:
	sed -i -e '/install.*FILES.*DESTINATION.*OPENJPEG_INSTALL_DOC_DIR/d' CMakeLists.txt || die

	# Install doxygen docs to the right directory:
	sed -i -e "s:DESTINATION\s*share/doc:\0/${PF}:" doc/CMakeLists.txt || die
}

multilib_src_configure() {
	local mycmakeargs=(
		-DOPENJPEG_INSTALL_LIB_DIR="$(get_libdir)"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_DOC=$(multilib_native_usex doc ON OFF)
		-DBUILD_CODEC=$(multilib_is_native_abi && echo ON || echo OFF)
		)

	cmake-utils_src_configure

	if use static-libs; then
		mycmakeargs=(
			-DOPENJPEG_INSTALL_LIB_DIR="$(get_libdir)"
			-DBUILD_TESTING="$(usex test)"
			-DBUILD_SHARED_LIBS=OFF
			-DBUILD_CODEC="$(usex test)"
			)
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_configure
	fi
}

multilib_src_compile() {
	cmake-utils_src_compile

	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_compile
	fi
}

multilib_src_test() {
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
				einfo "Test suite passed. Now new/unknown test failure found!"
			fi

			return 0
		fi
	fi
}

multilib_src_install() {
	if use static-libs; then
		BUILD_DIR=${BUILD_DIR}_static cmake-utils_src_install
	fi

	cmake-utils_src_install
}
