# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )

inherit cmake python-any-r1 toolchain-funcs

MY_TEST_UTILS="paho.mqtt.testing"
MY_TEST_COMMIT="577f955352e41205c554d44966c2908e90026345"
MY_LIVE_COMMIT="7db21329301b1f527c925dff789442db3ca3c1e7"

DESCRIPTION="An Eclipse Paho C client library for MQTT for Windows, Linux and MacOS."
HOMEPAGE="https://eclipse.org/paho"
SRC_URI="
	https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/eclipse/paho.mqtt.c/archive/${MY_LIVE_COMMIT}.tar.gz -> ${P}-live.tar.gz
	https://github.com/eclipse/${MY_TEST_UTILS}/archive/${MY_TEST_COMMIT}.tar.gz -> ${MY_TEST_UTILS}.tar.gz
"

LICENSE="EPL-2.0"
SLOT="1.3"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +high-performance +ssl test"

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

src_prepare(){
	cmake_src_prepare
	if use test; then
		# removing old certs
		rm -r "${S}"/test/ssl || die
		mv "${WORKDIR}"/paho.mqtt.c-"${MY_LIVE_COMMIT}"/test/ssl "${S}"/test/ssl || die

		mv "${WORKDIR}/${MY_TEST_UTILS}-${MY_TEST_COMMIT}" "${WORKDIR}/${MY_TEST_UTILS}" || die
	fi
}

src_configure(){
	local mycmakeargs=(
		-DPAHO_BUILD_SHARED=TRUE
		-DPAHO_HIGH_PERFORMANCE="$(usex high-performance "TRUE" "FALSE")"
		-DPAHO_WITH_SSL="$(usex ssl "TRUE" "FALSE")"
		-DPAHO_BUILD_DOCUMENTATION="$(usex doc "TRUE" "FALSE")"
		-DPAHO_BUILD_SAMPLES="$(usex examples "TRUE" "FALSE")"
		-DPAHO_ENABLE_TESTING="$(usex test "TRUE" "FALSE")"
	)
	cmake_src_configure
}

src_test() {
	if tc-is-cross-compiler; then
		elog "Disabling tests due to crosscompiling."
		return
	fi

	cd "${WORKDIR}/${MY_TEST_UTILS}/interoperability" || die

	${EPYTHON} startbroker.py -c localhost_testing.conf \
			   > "${T}/testbroker.log" &
	local -r startbroker_pid=$!

	${EPYTHON} "${S}"/test/mqttsas.py \
			   > "${T}/testmqttsas.log" &
	local -r mqttsas_pid=$!

	local port ports
	ports=(1883 1888{3..8})

	for port in ${ports[@]}; do
		einfo "Waiting for TCP port ${port} to become available"
		if timeout 30 bash -c \
				'until printf "" >/dev/tcp/${0}/${1} 2>> "${T}/portlog"; do sleep 1; done' \
				localhost "${port}"; then
			continue
		fi

		kill ${startbroker_pid} ${mqttsas_pid}
		die "Timeout waiting for port ${port} to become available"
	done

	local myctestargs=(
		-j 1
		--timeout 600
	)
	cmake_src_test

	kill ${startbroker_pid} ${mqttsas_pid} || die
}
