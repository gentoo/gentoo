# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="JSON Parser/Constructor for Lua"
HOMEPAGE="https://www.eharning.us/wiki/luajson/"
SRC_URI="https://github.com/harningt/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="luajit test"

# lunit not in the tree yet
RESTRICT="test"

RDEPEND="
	dev-lua/lpeg
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( dev-lang/lua:0 )
"
BDEPEND="
	virtual/pkgconfig
	test? ( dev-lua/luafilesystem )
"

DOCS=( README.md docs/ReleaseNotes-${PV}.txt docs/LuaJSON.txt )

# nothing to compile
src_compile() { :; }

src_install() {
	emake DESTDIR="${ED}" INSTALL_LMOD="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD $(usex luajit 'luajit' 'lua'))" install

	einstalldocs
}
