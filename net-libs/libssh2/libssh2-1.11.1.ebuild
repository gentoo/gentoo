# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="https://libssh2.org"
SRC_URI="https://libssh2.org/download/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="gcrypt mbedtls test zlib"
REQUIRED_USE="?? ( gcrypt mbedtls )"
RESTRICT="!test? ( test )"

RDEPEND="
	gcrypt? ( >=dev-libs/libgcrypt-1.5.3:0[${MULTILIB_USEDEP}] )
	!gcrypt? (
		mbedtls? ( net-libs/mbedtls:0=[${MULTILIB_USEDEP}] )
		!mbedtls? (
			>=dev-libs/openssl-1.0.1h-r2:0=[${MULTILIB_USEDEP}]
		)
	)
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11.0-mansyntax_sh.patch
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
		-DBUILD_STATIC_LIBS=OFF
		-DBUILD_TESTING=$(usex test)
		-DCRYPTO_BACKEND=${crypto_backend}
		-DENABLE_ZLIB_COMPRESSION=$(usex zlib)
	)

	if use test ; then
		# Pass separately to avoid unused var warnings w/ USE=-test
		mycmakeargs+=(
			-DRUN_SSHD_TESTS=OFF
			-DRUN_DOCKER_TESTS=OFF
		)
	fi

	cmake_src_configure
}

multilib_src_install_all() {
	einstalldocs
}
