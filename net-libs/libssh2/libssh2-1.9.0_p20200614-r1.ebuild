# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_ECLASS=cmake
inherit cmake-multilib

EGIT_COMMIT=6c7769dcc422250d14af1b06fce378b6ee009440
DESCRIPTION="Library implementing the SSH2 protocol"
HOMEPAGE="https://www.libssh2.org"
SRC_URI="https://github.com/libssh2/libssh2/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="gcrypt mbedtls zlib"
REQUIRED_USE="?? ( gcrypt mbedtls )"
RESTRICT="test"

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
