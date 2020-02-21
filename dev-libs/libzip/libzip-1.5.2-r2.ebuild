# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multibuild

DESCRIPTION="Library for manipulating zip archives"
HOMEPAGE="https://nih.at/libzip/"
SRC_URI="https://www.nih.at/libzip/${P}.tar.xz"

LICENSE="BSD"
SLOT="0/5"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="bzip2 doc gnutls libressl mbedtls ssl static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	sys-libs/zlib
	bzip2? ( app-arch/bzip2 )
	ssl? (
		gnutls? (
			dev-libs/nettle:0=
			>=net-libs/gnutls-3.6.5:=
		)
		!gnutls? (
			mbedtls? ( net-libs/mbedtls:= )
			!mbedtls? (
				!libressl? ( dev-libs/openssl:0= )
				libressl? ( dev-libs/libressl:0= )
			)
		)
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-mbedtls.patch" ) # bug 680820

pkg_setup() {
	# Upstream doesn't support building dynamic & static
	# simultaneously: https://github.com/nih-at/libzip/issues/76
	MULTIBUILD_VARIANTS=( shared $(usev static-libs) )
}

src_configure() {
	myconfigure() {
		local mycmakeargs=(
			-DBUILD_EXAMPLES=OFF # nothing is installed
			-DENABLE_COMMONCRYPTO=OFF # not in tree
			-DENABLE_BZIP2=$(usex bzip2)
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
				-DBUILD_DOC=$(usex doc)
				-DBUILD_REGRESS=$(usex test)
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
	[[ ${MULTIBUILD_VARIANT} = shared ]] && cmake_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
