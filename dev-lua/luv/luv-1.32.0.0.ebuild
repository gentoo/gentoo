# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils unpacker

# e.g. MY_PV = a.b.c-d
MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Bare libuv bindings for lua"
HOMEPAGE="https://github.com/luvit/luv"

LUA_COMPAT_PV="0.7"
SRC_URI="
	https://github.com/luvit/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/keplerproject/lua-compat-5.3/archive/v${LUA_COMPAT_PV}.tar.gz -> ${PN}-lua-compat-${LUA_COMPAT_PV}.tar.gz
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="luajit test"
RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"
DEPEND="
	>=dev-libs/libuv-1.32.0:=
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
	lua_compat_dir="${WORKDIR}/lua-compat-5.3-${LUA_COMPAT_PV}"
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
	ln -s "${BUILD_DIR}/libluv.so" "./luv.so" || die "Failed to symlink library for tests"
	${elua} "tests/run.lua" || die "Tests failed"
}
