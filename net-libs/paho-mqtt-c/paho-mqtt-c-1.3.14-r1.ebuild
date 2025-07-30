# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} pypy3 pypy3_11 )

inherit cmake python-any-r1 toolchain-funcs

TEST_UTILS="paho.mqtt.testing"
TEST_COMMIT="9d7bb80bb8b9d9cfc0b52f8cb4c1916401281103"

DESCRIPTION="An Eclipse Paho C client library for MQTT for Windows, Linux and MacOS."
HOMEPAGE="https://eclipse.org/paho"
SRC_URI="
	https://github.com/eclipse/paho.mqtt.c/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/eclipse/${TEST_UTILS}/archive/${TEST_COMMIT}.tar.gz -> ${TEST_UTILS}-${TEST_COMMIT}.tar.gz
"
S="${WORKDIR}/paho.mqtt.c-${PV}"

LICENSE="EPL-2.0"
SLOT="1.3"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples +high-performance +ssl test"

# Building samples needs ssl: #912262
REQUIRED_USE="examples? ( ssl )"

# Tests require net-redirections to be enabled in bash. See bug #915718
BDEPEND="
	doc? ( app-text/doxygen
		   media-gfx/graphviz )
	ssl? ( dev-libs/openssl )
	test? (
		${PYTHON_DEPS}
		app-shells/bash[net]
	)
"

# Tests can be run only if a MQTT broker is available
RESTRICT="!test? ( test )"

BUILD_DIR="${S}_build"

PATCHES=( "${FILESDIR}/${P}-fix-build-c23.patch" )

src_prepare(){
	cmake_src_prepare
	if use test; then
		mv "${WORKDIR}/${TEST_UTILS}-${TEST_COMMIT}" "${WORKDIR}/${TEST_UTILS}" || die
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

	cd "${WORKDIR}/${TEST_UTILS}/interoperability" || die

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
