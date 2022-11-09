# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="RPC/Serialization system with capabilities support"
HOMEPAGE="https://capnproto.org"
SRC_URI="https://github.com/sandstorm-io/capnproto/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${P}/c++

LICENSE="MIT"
SLOT="0/091"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+ssl test zlib"

RESTRICT="!test? ( test )"

RDEPEND="
	ssl? ( dev-libs/openssl:0= )
	zlib? ( sys-libs/zlib:0= )
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

src_configure() {
	if use arm || use ppc || use mips || [[ ${CHOST} == *i486* ]] ; then
		# append-libs won't work here, cmake doesn't respect it
		# ... and ldflags gets missed once
		append-flags -latomic
	fi

	local mycmakeargs=(
		-DWITH_OPENSSL=$(usex ssl)
		-DBUILD_TESTING=$(usex test)
		$(cmake_use_find_package zlib ZLIB)
	)
	cmake_src_configure
}

src_test() {
	cmake_build check
}
