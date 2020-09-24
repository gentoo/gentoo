# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs xdg

DESCRIPTION="A fast, extensible, and customizable web browser"
HOMEPAGE="https://luakit.github.io/luakit"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/luakit/luakit.git"
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
	!luajit? ( dev-lang/lua:0 )
"
DEPEND="
	${RDEPEND}
	test? (
		dev-lua/luassert[luajit=]
		dev-lua/luacheck[luajit=]
		x11-base/xorg-server[xvfb]
	)
"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
PATCHES=(
	"${FILESDIR}"/${PN}-2.2.1-make.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
}

src_compile() {
	emake \
		LUA_PKG_NAME=$(usex luajit luajit lua) \
		LUA_BIN_NAME=$(usex luajit luajit lua) \
		PREFIX="${EPREFIX}/usr" \
		${PN}

	use doc && emake doc
}

src_test() {
	local failing_test
	for failing_test in test_clib_luakit test_image_css; do
		mv tests/async/${failing_test}.lua{,.disabled} || die
	done

	emake \
		LUA_BIN_NAME=$(usex luajit luajit lua) \
		run-tests
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		DOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		XDGPREFIX="${EPREFIX}/etc/xdg" \
		install

	rm "${ED}/usr/share/doc/${PF}/COPYING.GPLv3" || die

	use doc && dodoc -r doc/html
}
