# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib git-r3

DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="https://www.libssh2.org"
EGIT_REPO_URI="https://github.com/libssh2/libssh2"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
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
DEPEND="${RDEPEND}"

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
		-DBUILD_TESTING=$(usex test)
		-DCRYPTO_BACKEND=${crypto_backend}
		-DENABLE_ZLIB_COMPRESSION=$(usex zlib)
		-DRUN_SSHD_TESTS=OFF
		-DRUN_DOCKER_TESTS=OFF
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
