# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindMbedTLS )

inherit cmake-multilib verify-sig

MY_P="${P}-alpha-dev"
DESCRIPTION="Library to execute a function when a specific event occurs on a file descriptor"
HOMEPAGE="
	https://libevent.org/
	https://github.com/libevent/libevent/
"
BASE_URI="https://github.com/libevent/libevent/releases/download/release-${PV}-alpha"
SRC_URI="
	${BASE_URI}/${MY_P}.tar.gz
	verify-sig? (
		${BASE_URI}/${MY_P}.tar.gz.asc
	)
"
S=${WORKDIR}/${MY_P}

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
BDEPEND="
	verify-sig? (
		sec-keys/openpgp-keys-libevent
	)
"

DOCS=( README.md ChangeLog{,-2.0} whatsnew-2.{0,1}.txt )
MULTILIB_WRAPPED_HEADERS=(
	/usr/include/event2/event-config.h
)
VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libevent.asc

PATCHES=(
	# signalfd-by-default breaks at least app-misc/tmux
	# https://github.com/libevent/libevent/pull/1486
	"${FILESDIR}/${P}-disable-signalfd.patch"
	"${FILESDIR}/${P}-cmake-install-paths.patch"
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
