# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib toolchain-funcs eutils

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication"
HOMEPAGE="https://github.com/brunoos/luasec http://www.inf.puc-rio.br/~brunoos/luasec/"
SRC_URI="https://github.com/brunoos/luasec/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="libressl"

RDEPEND="
	>=dev-lang/lua-5.1:0[deprecated]
	dev-lua/luasocket
	!libressl? ( dev-libs/openssl:0 ) libressl? ( dev-libs/libressl:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	sed -i -e "s/-O2//" src/Makefile || die
	lua src/options.lua -g /usr/include/openssl/ssl.h > src/options.h || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		linux
}

src_install() {
	emake \
		LUAPATH="${D}/$(pkg-config --variable INSTALL_LMOD lua)" \
		LUACPATH="${D}/$(pkg-config --variable INSTALL_CMOD lua)" \
		install
}
