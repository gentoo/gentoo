# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ngtcp2/ngtcp2.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ngtcp2/ngtcp2/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~hppa ~riscv"
fi

DESCRIPTION="Implementation of the IETF QUIC Protocol"
HOMEPAGE="https://github.com/ngtcp2/ngtcp2/"

LICENSE="MIT"
SLOT="0/0"
IUSE="+gnutls openssl +ssl test"
REQUIRED_USE="ssl? ( || ( gnutls openssl ) )"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	ssl? (
		gnutls? ( >=net-libs/gnutls-3.7.2:0= )
		openssl? (
			>=dev-libs/openssl-1.1.1:0=
		)
	)"
DEPEND="${RDEPEND}
	test? ( >=dev-util/cunit-2.1[${MULTILIB_USEDEP}] )"
RESTRICT="!test? ( test )"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_GNUTLS=$(usex gnutls)
		-DENABLE_OPENSSL=$(usex openssl)
		-DENABLE_BORINGSSL=OFF
		-DENABLE_PICOTLS=OFF
		-DENABLE_WOLFSSL=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Libev=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Libnghttp3=ON
	)
	cmake_src_configure
}

multilib_src_test() {
	cmake_build check
}
