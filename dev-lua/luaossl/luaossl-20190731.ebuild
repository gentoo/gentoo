# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P=${PN}-rel-${PV}
DESCRIPTION="Most comprehensive OpenSSL module in the Lua universe."
HOMEPAGE="https://github.com/wahern/luaossl"
SRC_URI="https://github.com/wahern/luaossl/archive/rel-${PV}.tar.gz -> ${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:0 )
	dev-libs/openssl:0[-bindist]
	!dev-lua/lua-openssl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	LUA_VERSION="$($(tc-getPKG_CONFIG) --variable=$(usex luajit abiver V) $(usex luajit luajit lua))"
}

src_compile() {
	emake CC="$(tc-getCC)" prefix="${EPREFIX}/usr" openssl${LUA_VERSION}
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" install${LUA_VERSION}
}
