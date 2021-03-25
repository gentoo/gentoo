# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_ECLASS=cmake
inherit git-r3 cmake-multilib

DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="https://www.libssh2.org"
EGIT_REPO_URI="https://github.com/libssh2/libssh2"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="gcrypt libressl mbedtls zlib"
REQUIRED_USE="?? ( gcrypt mbedtls )"
RESTRICT="test"

RDEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	!gcrypt? (
		mbedtls? ( net-libs/mbedtls:0=[${MULTILIB_USEDEP}] )
		!mbedtls? (
			!libressl? ( >=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}] )
			libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		)
	)
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.0-mansyntax_sh.patch
)

multilib_src_configure() {
	local crypto_backend=OpenSSL
	if use gcrypt; then
		crypto_backend=Libgcrypt
	elif use mbedtls; then
		crypto_backend=mbedTLS
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DCRYPTO_BACKEND=${crypto_backend}
		-DENABLE_ZLIB_COMPRESSION=$(usex zlib)
	)
	cmake_src_configure
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -delete || die
}
