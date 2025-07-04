# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( FindMbedTLS )

inherit cmake flag-o-matic

DESCRIPTION="Library for manipulating zip archives"
HOMEPAGE="https://nih.at/libzip/"
SRC_URI="https://www.nih.at/libzip/${P}.tar.xz"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="bzip2 gnutls lzma mbedtls ssl test tools zstd"
REQUIRED_USE="test? ( ssl tools )"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/zlib
	bzip2? ( app-arch/bzip2:= )
	lzma? ( app-arch/xz-utils )
	ssl? (
		gnutls? (
			dev-libs/nettle:=
			>=net-libs/gnutls-3.6.5:=
		)
		!gnutls? (
			mbedtls? ( net-libs/mbedtls:3= )
			!mbedtls? ( dev-libs/openssl:= )
		)
	)
	zstd? ( >=app-arch/zstd-1.4.0:= )
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-util/nihtest )"

PATCHES=(
	"${FILESDIR}/libzip-1.11.4-mbedtls-3.patch"
)

src_configure() {
	append-lfs-flags
	local mycmakeargs=(
		-DBUILD_DOC=ON
		-DBUILD_OSSFUZZ=OFF
		-DBUILD_EXAMPLES=OFF # nothing is installed
		-DENABLE_COMMONCRYPTO=OFF # not in tree
		-DENABLE_BZIP2=$(usex bzip2)
		-DENABLE_LZMA=$(usex lzma)
		-DENABLE_ZSTD=$(usex zstd)
		-DBUILD_REGRESS=$(usex test)
		-DBUILD_TOOLS=$(usex tools)
	)

	if use ssl; then
		if use gnutls; then
			mycmakeargs+=(
				-DENABLE_GNUTLS=$(usex gnutls)
				-DENABLE_MBEDTLS=OFF
				-DENABLE_OPENSSL=OFF
			)
		elif use mbedtls; then
			mycmakeargs+=(
				-DENABLE_GNUTLS=OFF
				-DENABLE_MBEDTLS=$(usex mbedtls)
				-DENABLE_OPENSSL=OFF
			)
		else
			mycmakeargs+=(
				-DENABLE_GNUTLS=OFF
				-DENABLE_MBEDTLS=OFF
				-DENABLE_OPENSSL=ON
			)
		fi
	else
		mycmakeargs+=(
			-DENABLE_GNUTLS=OFF
			-DENABLE_MBEDTLS=OFF
			-DENABLE_OPENSSL=OFF
		)
	fi
	cmake_src_configure
}
