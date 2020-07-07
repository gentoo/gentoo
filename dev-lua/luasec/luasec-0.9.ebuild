# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication"
HOMEPAGE="https://github.com/brunoos/luasec"
SRC_URI="https://github.com/brunoos/luasec/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="libressl"

RDEPEND="
	>=dev-lang/lua-5.1:0[deprecated]
	dev-lua/luasocket
	!libressl? ( dev-libs/openssl:0= ) libressl? ( dev-libs/libressl:= )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i -e "s/-O2//" src/Makefile || die
	lua src/options.lua -g /usr/include/openssl/ssl.h > src/options.c || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" LD="$(tc-getCC)" LIB_PATH="" \
		linux
}

src_install() {
	emake \
		LUAPATH="${D}/$(pkg-config --variable INSTALL_LMOD lua)" \
		LUACPATH="${D}/$(pkg-config --variable INSTALL_CMOD lua)" \
		install
}
