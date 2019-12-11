# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV="${PV//_p/-}"

DESCRIPTION="OpenSSL binding for Lua"
HOMEPAGE="https://github.com/zhaozg/lua-openssl"
LUA_AUX_COMMIT="b56f6937096acea34ddf241ec7ea08ac52414d18"
LUA_COMPAT_COMMIT="a1735f6e6bd17588fcaf98720f0548c4caa23b34"
SRC_URI="https://github.com/zhaozg/lua-openssl/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
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
	!dev-lua/luacrypto
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	rmdir deps/auxiliar deps/lua-compat || die
	mv "${WORKDIR}/lua-auxiliar-${LUA_AUX_COMMIT}" deps/auxiliar || die
	mv "${WORKDIR}/lua-compat-5.3-${LUA_COMPAT_COMMIT}" deps/lua-compat || die

	default
}

src_configure() {
	tc-export PKG_CONFIG
	LUA_VERSION="$(${PKG_CONFIG} --variable=$(usex luajit abiver V) $(usex luajit luajit lua))"
	LUA_CFLAGS="$(${PKG_CONFIG} $(usex luajit luajit lua) --cflags) ${CFLAGS}"
	LUA_LIBS="$(${PKG_CONFIG} $(usex luajit luajit lua) --libs) ${LDFLAGS}"
	INSTALL_CMOD="$(${PKG_CONFIG} $(usex luajit luajit lua) --variable=INSTALL_CMOD)"
	INSTALL_LMOD="$(${PKG_CONFIG} $(usex luajit luajit lua) --variable=INSTALL_LMOD)"

	export LUA_VERSION LUA_CFLAGS LUA_LIBS
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() {
	emake CC="$(tc-getCC)" test
}

src_install() {
	emake PREFIX="${ED}/usr" LUA_LIBDIR="${ED}/${INSTALL_CMOD}" install

	# install lua code as well
	insinto "${INSTALL_LMOD}"
	doins -r lib/*

	einstalldocs
}
