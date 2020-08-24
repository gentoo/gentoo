# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Bindings for POSIX APIs"
HOMEPAGE="https://luaposix.github.io/luaposix/ https://github.com/luaposix/luaposix"
SRC_URI="https://github.com/luaposix/luaposix/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-lang/lua:0=
	dev-lua/lua-bit32"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	./build-aux/luke package="${PN}" version="${PV}" \
		PREFIX="${ED}/usr" \
		INST_LIBDIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)" \
		INST_LUADIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" \
		CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die
}

src_install() {
	./build-aux/luke install \
		PREFIX="${ED}/usr" \
		INST_LIBDIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)" \
		INST_LUADIR="${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)" \
		|| die
	dodoc -r doc NEWS.md README.md
}
