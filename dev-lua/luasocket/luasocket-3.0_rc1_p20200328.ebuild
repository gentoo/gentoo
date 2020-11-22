# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_COMMIT="5b18e475f38fcf28429b1cc4b17baee3b9793a62"
LUA_REQ_USE="${MULTILIB_USEDEP}"

inherit flag-o-matic multilib multilib-minimal toolchain-funcs

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
RESTRICT="test"

RDEPEND=">=dev-lang/lua-5.1.5-r2:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

HTML_DOCS="doc/."

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-O2 -ggdb3//g' -i src/makefile || die

	# Workaround for 32-bit systems
	append-cflags -fno-stack-protector

	multilib_copy_sources
}

multilib_src_compile() {
	local myemakeargs=(
		"CC=$(tc-getCC)"
		"LD=$(tc-getCC)"
		"LDFLAGS_linux=-O -fpic -shared -o"
		"LUAINC_linux=$($(tc-getPKG_CONFIG) --variable INSTALL_INC lua)/lua$($(tc-getPKG_CONFIG) --variable V lua)"
		"LUAV=$($(tc-getPKG_CONFIG) --variable V lua)"
		"MYCFLAGS=${CFLAGS}"
		"MYLDFLAGS=${LDFLAGS}"
	)

	emake "${myemakeargs[@]}" all
}

multilib_src_install() {
	local myemakeargs=(
		"CDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"
		"DESTDIR=${ED}"
		"LDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"
		"LUAPREFIX_linux="
	)

	emake "${myemakeargs[@]}" install
	emake "${myemakeargs[@]}" install-unix

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_INC lua)/$($(tc-getPKG_CONFIG) --variable V lua)"/luasocket
	doins src/*.h
}

multilib_src_install_all() {
	einstalldocs
}
