# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib git-r3

DESCRIPTION="HTTP/2 C Library"
HOMEPAGE="https://nghttp2.org/"
EGIT_REPO_URI="https://github.com/nghttp2/nghttp2.git"

LICENSE="MIT"
SLOT="0/1.14" # 1.<SONAME>
IUSE="debug hpack-tools jemalloc static-libs systemd test utils xml"

RESTRICT="!test? ( test )"

SSL_DEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist(-),${MULTILIB_USEDEP}]
"
RDEPEND="
	hpack-tools? ( >=dev-libs/jansson-2.5:= )
	jemalloc? ( dev-libs/jemalloc:=[${MULTILIB_USEDEP}] )
	utils? (
		${SSL_DEPEND}
		>=dev-libs/libev-4.15[${MULTILIB_USEDEP}]
		>=sys-libs/zlib-1.2.3[${MULTILIB_USEDEP}]
		net-dns/c-ares:=[${MULTILIB_USEDEP}]
	)
	systemd? ( >=sys-apps/systemd-209 )
	xml? ( >=dev-libs/libxml2-2.7.7:2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cunit-2.1[${MULTILIB_USEDEP}] )"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_EXAMPLES=OFF
		-DENABLE_FAILMALLOC=OFF
		-DENABLE_WERROR=OFF
		-DENABLE_THREADS=ON
		-DENABLE_DEBUG=$(usex debug)
		-DENABLE_HPACK_TOOLS=$(multilib_native_usex hpack-tools)
		$(cmake_use_find_package hpack-tools Jansson)
		-DWITH_JEMALLOC=$(multilib_native_usex jemalloc)
		-DENABLE_STATIC_LIB=$(usex static-libs)
		$(cmake_use_find_package systemd Systemd)
		$(cmake_use_find_package test CUnit)
		-DENABLE_APP=$(multilib_native_usex utils)
		-DWITH_LIBXML2=$(multilib_native_usex xml)
	)
	cmake_src_configure
}

multilib_src_test() {
	eninja check
}
