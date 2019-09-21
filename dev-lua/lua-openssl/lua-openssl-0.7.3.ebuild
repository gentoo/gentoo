# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="OpenSSL binding for Lua"
HOMEPAGE="https://github.com/zhaozg/lua-openssl"
LUA_AUX_COMMIT="b56f6937096acea34ddf241ec7ea08ac52414d18"
LUA_COMPAT_COMMIT="daebe77a2f498817713df37f0bb316db1d82222f"
SRC_URI="https://github.com/zhaozg/lua-openssl/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/zhaozg/lua-auxiliar/archive/${LUA_AUX_COMMIT}.tar.gz -> ${PN}-aux-${LUA_AUX_COMMIT}.tar.gz
	https://github.com/keplerproject/lua-compat-5.3/archive/${LUA_COMPAT_COMMIT}.tar.gz -> ${PN}-compat-${LUA_COMPAT_COMMIT}.tar.gz"

LICENSE="MIT openssl PHP-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1:0 )
	libressl? ( <dev-libs/libressl-2.7.0:0= )
	!libressl? ( dev-libs/openssl:0=[-bindist] )
	!dev-lua/luaossl
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=("${FILESDIR}/0001-fix-libressl-compat.patch")

src_unpack() {
	unpack "${P}.tar.gz"
	pushd "${WORKDIR}/${P}/deps" > /dev/null || die
	unpack "${PN}-aux-${LUA_AUX_COMMIT}.tar.gz"
	unpack "${PN}-compat-${LUA_COMPAT_COMMIT}.tar.gz"
	rmdir auxiliar lua-compat || die
	mv "lua-auxiliar-${LUA_AUX_COMMIT}" auxiliar || die
	mv "lua-compat-5.3-${LUA_COMPAT_COMMIT}" lua-compat || die
	popd > /dev/null || die
}

src_configure() {
	tc-export PKG_CONFIG
	LUA_VERSION="$(${PKG_CONFIG} --variable=$(usex luajit abiver V) $(usex luajit luajit lua))"
	LUA_CFLAGS="$(${PKG_CONFIG} $(usex luajit luajit lua) --cflags) ${CFLAGS}"
	LUA_LIBS="$(${PKG_CONFIG} $(usex luajit luajit lua) --libs) ${LDFLAGS}"

	export LUA_VERSION LUA_CFLAGS LUA_LIBS
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake PREFIX="${ED}/usr" install
	einstalldocs
}
