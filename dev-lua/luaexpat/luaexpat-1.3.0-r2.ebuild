# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal toolchain-funcs

DESCRIPTION="LuaExpat is a SAX XML parser based on the Expat library"
HOMEPAGE="http://www.keplerproject.org/luaexpat/"
SRC_URI="http://matthewwild.co.uk/projects/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"

RDEPEND=">=dev-lang/lua-5.1.5-r2:0[${MULTILIB_USEDEP}]
	>=dev-libs/expat-2.1.0-r3[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i -e 's:-g::' -e 's:-O2::' Makefile || die "sed failed"
	multilib_copy_sources
}

multilib_src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LUA_INC="-I$($(tc-getPKG_CONFIG) --variable INSTALL_INC lua)"
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		LUA_LDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" \
		LUA_CDIR="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)" \
		LUA_INC="-I$($(tc-getPKG_CONFIG) --variable INSTALL_INC lua)" \
		install
}

multilib_src_install_all() {
	dodoc -r README doc/*
}
