# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils unpacker

MY_PV="${PV/_p/-}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Bare libuv bindings for lua"
HOMEPAGE="https://github.com/luvit/luv"
# XXX: Remember to check this hash between bumps!
# https://github.com/luvit/luv/tree/master/deps
LUA_COMPAT_HASH="daebe77a2f498817713df37f0bb316db1d82222f"
SRC_URI="
	https://github.com/luvit/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/keplerproject/lua-compat-5.3/archive/${LUA_COMPAT_HASH}.tar.gz -> ${PN}-lua-compat-${PV}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
DEPEND="
	dev-libs/libuv:=
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Fix libdir
	# Match '/lib/' and '/lib"' without capturing / or ", replacing with libdir
	sed -i -r "s/\/lib(\"|\/)/\/$(get_libdir)\1/g" CMakeLists.txt || die "Failed to sed CMakeLists.txt"
	cmake-utils_src_prepare
}

src_configure() {
	lua_compat_dir="${WORKDIR}/lua-compat-5.3-${LUA_COMPAT_HASH}"
	local mycmakeargs=(
		-DBUILD_MODULE=OFF
		-DLUA_BUILD_TYPE=System
		-DLUA_COMPAT53_DIR="${lua_compat_dir}"
		-DWITH_LUA_ENGINE=$(usex luajit LuaJIT Lua)
		-DWITH_SHARED_LIBUV=ON
	)
	cmake-utils_src_configure
}

src_test() {
	local elua="$(usex luajit luajit lua)"
	# We need to copy the library back so that the tests see it
	cp "${BUILD_DIR}/libluv.so" "./luv.so" || die "Failed to copy library for tests"
	${elua} "tests/run.lua" || die "Tests failed"
}
