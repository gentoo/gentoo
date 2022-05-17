# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multibuild flag-o-matic

DESCRIPTION="Library for manipulating zip archives"
HOMEPAGE="https://nih.at/libzip/"
SRC_URI="https://www.nih.at/libzip/${P}.tar.xz"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="bzip2 gnutls lzma mbedtls ssl static-libs test tools zstd"
REQUIRED_USE="test? ( tools )"

RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/zlib
	bzip2? ( app-arch/bzip2:= )
	lzma? ( app-arch/xz-utils )
	ssl? (
		gnutls? (
			dev-libs/nettle:0=
			>=net-libs/gnutls-3.6.5:=
		)
		!gnutls? (
			mbedtls? ( net-libs/mbedtls:= )
			!mbedtls? ( dev-libs/openssl:0= )
		)
	)
	zstd? ( app-arch/zstd )
"
RDEPEND="${DEPEND}"

pkg_setup() {
	# Upstream doesn't support building dynamic & static
	# simultaneously: https://github.com/nih-at/libzip/issues/76
	MULTIBUILD_VARIANTS=( shared $(usev static-libs) )
}

src_configure() {
	append-lfs-flags
	myconfigure() {
		local mycmakeargs=(
			-DBUILD_EXAMPLES=OFF # nothing is installed
			-DENABLE_COMMONCRYPTO=OFF # not in tree
			-DENABLE_BZIP2=$(usex bzip2)
			-DENABLE_LZMA=$(usex lzma)
			-DENABLE_ZSTD=$(usex zstd)
		)
		if [[ ${MULTIBUILD_VARIANT} = static-libs ]]; then
			mycmakeargs+=(
				-DBUILD_DOC=OFF
				-DBUILD_EXAMPLES=OFF
				-DBUILD_SHARED_LIBS=OFF
				-DBUILD_TOOLS=OFF
			)
		else
			mycmakeargs+=(
				-DBUILD_DOC=ON
				-DBUILD_REGRESS=$(usex test)
				-DBUILD_TOOLS=$(usex tools)
			)
		fi

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

	multibuild_foreach_variant myconfigure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	run_tests() {
		[[ ${MULTIBUILD_VARIANT} = shared ]] && cmake_src_test
	}

	multibuild_foreach_variant run_tests
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
