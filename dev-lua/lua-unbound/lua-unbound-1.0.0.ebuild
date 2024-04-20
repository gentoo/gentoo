# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} luajit )
MY_PN="${PN/-/}"
MY_P="${MY_PN}-${PV}"

inherit lua toolchain-funcs

DESCRIPTION="A binding to libunbound for Lua"
HOMEPAGE="https://www.zash.se/luaunbound.html"
SRC_URI="https://code.zash.se/dl/${MY_PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	net-dns/unbound
"
DEPEND="${RDEPEND}"

DOCS=( "README.markdown" )

src_prepare() {
	default

	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS} -fPIC $(lua_get_CFLAGS)"
		LD="$(tc-getCC)"
		LDFLAGS="${LDFLAGS} -shared"
	)

	emake "${myemakeargs[@]}"

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		DESTDIR="${ED}"
		LUA_LIBDIR="$(lua_get_cmod_dir)"
	)

	emake "${myemakeargs[@]}" install
	einstalldocs

	popd
}

src_install() {
	lua_foreach_impl lua_src_install
}
