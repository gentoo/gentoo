# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="5b18e475f38fcf28429b1cc4b17baee3b9793a62"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Networking support library for the Lua language"
HOMEPAGE="
	http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/
	https://github.com/diegonehab/luasocket
"
SRC_URI="https://github.com/diegonehab/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="luajit"
RESTRICT="test"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS="doc/."

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-O2 -ggdb3//g' -i src/makefile || die

	# Workaround for 32-bit systems
	append-cflags -fno-stack-protector
}

src_compile() {
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LD=$(tc-getCC)"
		"LDFLAGS_linux=-O -fpic -shared -o"
		"LUAINC_linux=$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))"
		"LUAV=5.1"
		"MYCFLAGS=${CFLAGS}"
		"MYLDFLAGS=${LDFLAGS}"
	)

	emake "${myemakeargs[@]}" all
}

src_install() {
	local myemakeargs=(
		"CDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD $(usex luajit 'luajit' 'lua'))"
		"DESTDIR=${ED}"
		"LDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))"
		"LUAPREFIX_linux="
	)

	emake "${myemakeargs[@]}" install
	emake "${myemakeargs[@]}" install-unix

	insinto "$($(tc-getPKG_CONFIG) --variable includedir $(usex luajit 'luajit' 'lua'))/luasocket"
	doins src/*.h

	einstalldocs
}
