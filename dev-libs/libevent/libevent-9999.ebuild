# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindMbedTLS )

inherit cmake-multilib git-r3

DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent/
"
EGIT_REPO_URI="https://github.com/libevent/libevent.git"

LICENSE="BSD"
SLOT="0/2.2.1-r2"
KEYWORDS=""
IUSE="
	+clock-gettime debug malloc-replacement mbedtls +ssl static-libs
	test verbose-debug
"
# TODO: hangs
RESTRICT="test"

DEPEND="
	mbedtls? ( net-libs/mbedtls:3=[${MULTILIB_USEDEP}] )
	ssl? ( >=dev-libs/openssl-1.0.1h-r2:=[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${DEPEND}
"

DOCS=( README.md ChangeLog{,-2.0,-2.1} whatsnew-2.{0,1}.txt )
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)

multilib_src_configure() {
	local mycmakeargs=(
		-DEVENT__DISABLE_CLOCK_GETTIME=$(usex !clock-gettime)
		-DEVENT__DISABLE_DEBUG_MODE=$(usex !debug)
		-DEVENT__DISABLE_MBEDTLS=$(usex !mbedtls)
		-DEVENT__DISABLE_MM_REPLACEMENT=$(usex !malloc-replacement)
		-DEVENT__DISABLE_OPENSSL=$(usex !ssl)
		-DEVENT__LIBRARY_TYPE=$(usex static-libs BOTH SHARED)
		-DCMAKE_DEBUG_POSTFIX=""
	)
	cmake_src_configure
}
