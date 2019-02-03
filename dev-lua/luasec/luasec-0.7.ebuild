# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib toolchain-funcs

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication"
HOMEPAGE="https://github.com/brunoos/luasec"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/brunoos/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/brunoos/luasec/archive/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S=${WORKDIR}/${PN}-${P}
fi

LICENSE="MIT"
SLOT="0"
IUSE="libressl"

RDEPEND="
	>=dev-lang/lua-5.1:0[deprecated]
	dev-lua/luasocket
	!libressl? ( dev-libs/openssl:0= ) libressl? ( dev-libs/libressl:= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
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
