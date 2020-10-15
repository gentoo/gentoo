# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit cmake lua unpacker

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
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${LUA_REQUIRED_USE}"

BDEPEND="virtual/pkgconfig"
DEPEND="${LUA_DEPS}
	>=dev-libs/libuv-1.32.0:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.32.0.0-cmake_lua_version.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# Fix libdir
	# Match '/lib/' and '/lib"' without capturing / or ", replacing with libdir
	sed -i -r "s/\/lib(\"|\/)/\/$(get_libdir)\1/g" CMakeLists.txt || die "Failed to sed CMakeLists.txt"
	cmake_src_prepare
}

lua_src_configure() {
	lua_compat_dir="${WORKDIR}/lua-compat-5.3-${LUA_COMPAT_PV}"

	local mycmakeargs=(
		-DINSTALL_LIB_DIR="$(lua_get_cmod_dir)"
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

	cmake_src_configure
}

lua_src_test() {
	# We need to copy the implementation-specific library back so that the tests see it
	rm -f ./luv.so
	ln -s "${BUILD_DIR}/libluv.so" "./luv.so" || die "Failed to symlink library for tests"
	${ELUA} "tests/run.lua" || die "Tests failed"
}

lua_src_install() {
	cmake_src_install
	mkdir -p "${ED}"/usr/$(get_libdir)/pkgconfig && \
	mv "${ED}$(lua_get_cmod_dir)"/pkgconfig/libluv.pc \
		"${ED}"/usr/$(get_libdir)/pkgconfig/libluv-${ELUA}.pc || \
	die "Failed make pkgconfig file for ${ELUA} implementation-specific"
	rmdir "${ED}$(lua_get_cmod_dir)"/pkgconfig || die
}

src_configure() {
	lua_foreach_impl lua_src_configure
}

src_compile() {
	lua_foreach_impl cmake_src_compile
}

src_test() {
	lua_foreach_impl lua_src_test
}

src_install() {
	lua_foreach_impl lua_src_install
}

pkg_postinst() {
	ewarn "Please note that in order to properly support multiple Lua implementations,"
	ewarn "this ebuild of ${PN} installs its library files into implementation-specific"
	ewarn "module directories, as well as multiple .pc files named after implementations"
	ewarn "(e.g. 'libluv-lua5.3.pc'). Since upstream by default only supports a single"
	ewarn "Lua implementation at a time and thus only provides a single, unversioned"
	ewarn ".pc file, projects depending on ${PN} might require changes in order to"
	ewarn "support the multi-implementation approach."
}
