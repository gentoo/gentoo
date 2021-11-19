# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="5b18e475f38fcf28429b1cc4b17baee3b9793a62"
LUA_COMPAT=( lua5-{1..4} luajit )
MY_P="${PN}-${EGIT_COMMIT}"

inherit lua toolchain-funcs

DESCRIPTION="Networking support library for the Lua language"
HOMEPAGE="
	http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/
	https://github.com/diegonehab/luasocket
"
SRC_URI="https://github.com/diegonehab/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="test"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS="doc/."

PATCHES=(
	"${FILESDIR}/${P}_publish_API.patch"
	"${FILESDIR}/${P}_makefile.patch"
)

src_prepare() {
	default
	lua_copy_sources
}

lua_src_compile() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LD=$(tc-getCC)"
		"LUAINC_linux=$(lua_get_include_dir)"
		"LUAV=${ELUA}"
		"MIME_V=1.0.3-${ELUA}"
		"MYCFLAGS=${CFLAGS}"
		"MYLDFLAGS=${LDFLAGS}"
		"SOCKET_V=3.0-rc1-${ELUA}"
	)

	emake "${myemakeargs[@]}" all

	popd
}

src_compile() {
	lua_foreach_impl lua_src_compile
}

lua_src_install() {
	pushd "${BUILD_DIR}" || die

	local myemakeargs=(
		"CDIR=$(lua_get_cmod_dir)"
		"DESTDIR=${ED}"
		"LDIR=$(lua_get_lmod_dir)"
		"LUAPREFIX_linux="
		"MIME_V=1.0.3-${ELUA}"
		"SOCKET_V=3.0-rc1-${ELUA}"
	)

	emake "${myemakeargs[@]}" install
	emake "${myemakeargs[@]}" install-unix

	insinto "$(lua_get_include_dir)"/luasocket
	doins src/*.h

	popd
}

src_install() {
	lua_foreach_impl lua_src_install

	einstalldocs
}
