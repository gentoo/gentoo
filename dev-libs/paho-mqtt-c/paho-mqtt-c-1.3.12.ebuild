# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )

inherit cmake python-any-r1 toolchain-funcs

MY_TEST_UTILS="paho.mqtt.testing"
MY_TEST_COMMIT="577f955352e41205c554d44966c2908e90026345"

DESCRIPTION="An Eclipse Paho C client library for MQTT for Windows, Linux and MacOS."
HOMEPAGE="https://eclipse.org/paho"
SRC_URI="
	https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/eclipse/${MY_TEST_UTILS}/archive/${MY_TEST_COMMIT}.tar.gz -> ${MY_TEST_UTILS}.tar.gz
"

LICENSE="EPL-2.0"
SLOT="1.3"
KEYWORDS="~amd64 ~x86"
IUSE="+high-performance +ssl doc test"

BDEPEND="
	doc? ( app-doc/doxygen
	       media-gfx/graphviz )
	ssl? ( dev-libs/openssl )
	test? ( dev-lang/python )
"

# Tests can be run only if a MQTT broker is available
RESTRICT="!test? ( test )"

S="${WORKDIR}/paho.mqtt.c-${PV}"

BUILD_DIR="${S}_build"

src_configure(){
	local mycmakeargs=(
	-DPAHO_BUILD_SHARED=TRUE
	-DPAHO_HIGH_PERFORMANCE="$(usex high-performance "TRUE" "FALSE")"
	-DPAHO_WITH_SSL="$(usex ssl "TRUE" "FALSE")"
	-DPAHO_BUILD_DOCUMENTATION="$(usex doc "TRUE" "FALSE")"
	-DPAHO_ENABLE_TESTING="$(usex test "TRUE" "FALSE")"
	)
	cmake_src_configure
	if use test; then
		mv "${WORKDIR}"/"${MY_TEST_UTILS}"-"${MY_TEST_COMMIT}" "${WORKDIR}"/"${MY_TEST_UTILS}" || die
		# a subdir in test
		mv "${WORKDIR}"/"${MY_TEST_UTILS}" "${BUILD_DIR}"/test/ || die
		cp "${S}"/test/*.py "${BUILD_DIR}"/test/ || die
	fi
}

src_test() {
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi
	if use test; then
		echo "RUNNING TESTS"

		${EPYTHON} "${BUILD_DIR}"/test/"${MY_TEST_UTILS}"/interoperability/startbroker.py -c \
		"${BUILD_DIR}"/test/"${MY_TEST_UTILS}"/interoperability/localhost_testing.conf &

		${EPYTHON} "${BUILD_DIR}"/test/mqttsas.py &
		cmake_src_test
	fi
}
