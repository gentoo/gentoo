# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A fast, light, simple to use micro-browser using WebKit and Lua"
HOMEPAGE="https://luakit.github.io/luakit"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/luakit/luakit.git"
else
	SRC_URI="https://github.com/luakit/luakit/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="doc luajit test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/glib:2
	dev-lua/luafilesystem[luajit=]
	net-libs/webkit-gtk:4=
	x11-libs/gtk+:3
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	test? (
		dev-lua/luassert[luajit=]
		dev-lua/luacheck[luajit=]
		x11-base/xorg-server[xvfb]
	)"

PATCHES=(
	"${FILESDIR}"/${PN}-cflags.patch
	"${FILESDIR}"/${PN}-fix_tests.patch
)

src_compile() {
	emake \
		CC=$(tc-getCC) \
		PREFIX="${EPREFIX}/usr" \
		XDGPREFIX="${EPREFIX}/etc/xdg" \
		LUA_PKG_NAME=$(usex luajit 'luajit' 'lua') \
		LUA_BIN_NAME=$(usex luajit 'luajit' 'lua') \
		all

	use doc && emake doc
}

src_test() {
	emake \
		LUA_PKG_NAME=$(usex luajit 'luajit' 'lua') \
		LUA_BIN_NAME=$(usex luajit 'luajit' 'lua') \
		run-tests
}

src_install() {
	emake \
		LUA_PKG_NAME=$(usex luajit 'luajit' 'lua') \
		LUA_BIN_NAME=$(usex luajit 'luajit' 'lua') \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		DOCDIR="${ED}/usr/share/doc/${PF}" \
		XDGPREFIX="${ED}/etc/xdg" \
		install

	rm "${ED}/usr/share/doc/${PF}/COPYING.GPLv3" || die

	use doc && dodoc -r doc/html
}
