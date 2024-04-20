# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )

inherit cmake flag-o-matic lua-single unpacker

# e.g. MY_PV = a.b.c-d
MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Bare libuv bindings for lua"
HOMEPAGE="https://github.com/luvit/luv"

LUA_COMPAT_PV="0.10"
SRC_URI="
	https://github.com/luvit/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/keplerproject/lua-compat-5.3/archive/v${LUA_COMPAT_PV}.tar.gz -> ${PN}-lua-compat-${LUA_COMPAT_PV}.tar.gz
"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 ~riscv x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"
DEPEND="${LUA_DEPS}
	>=dev-libs/libuv-$(ver_cut 1-2):="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.43.0.0-cmake_lua_version.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Fix libdir
	# Match '/lib/' and '/lib"' without capturing / or ", replacing with libdir
	sed -i -r "s/\/lib(\"|\/)/\/$(get_libdir)\1/g" CMakeLists.txt || die "Failed to sed CMakeLists.txt"
	cmake_src_prepare
}

# This could in theory be multi-impl (and we have an ebuild in git history,
# 1.32.0.0-r101, which implements it) - the only revdep currently in the tree,
# app-editors/neovim, actually links against luv instead of trying to load it
# as a module. We could probably implement some sort of a hack for this
# - but given how messy it would be, don't bother unless someone actually requests
# luv multi-impl support.
src_configure() {
	lua_compat_dir="${WORKDIR}/lua-compat-5.3-${LUA_COMPAT_PV}"

	local mycmakeargs=(
		-DBUILD_MODULE=OFF
		-DLUA_BUILD_TYPE=System
		-DLUA_COMPAT53_DIR="${lua_compat_dir}"
		-DWITH_SHARED_LIBUV=ON
	)
	if [[ ${ELUA} == luajit ]]; then
		mycmakeargs+=(
			-DWITH_LUA_ENGINE=LuaJIT
		)
	else
		mycmakeargs+=(
			-DWITH_LUA_ENGINE=Lua
			-DLUA_VERSION=$(ver_cut 1-2 $(lua_get_version))
		)
	fi

	if [[ ${CHOST} == *-darwin* ]] ; then
		append-ldflags "-undefined dynamic_lookup"
	fi

	cmake_src_configure
}

src_test() {
	# We need to copy the library back so that the tests see it
	ln -s "${BUILD_DIR}/libluv.so" "./luv.so" || die "Failed to symlink library for tests"
	${ELUA} "tests/run.lua" || die "Tests failed"
}
