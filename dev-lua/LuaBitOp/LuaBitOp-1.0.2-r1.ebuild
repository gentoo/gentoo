# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
inherit toolchain-funcs multilib-minimal

DESCRIPTION="Bit Operations Library for the Lua Programming Language"
HOMEPAGE="http://bitop.luajit.org"
SRC_URI="http://bitop.luajit.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1.5-r2:*[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	multilib_copy_sources
}

multilib_src_compile()
{
	emake CC="$(tc-getCC)" INCLUDES= CCOPT=
}

multilib_src_test() {
	# tests use native lua interpreter
	multilib_is_native_abi && default
}

multilib_src_install()
{
	local instdir="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"
	exeinto "${instdir#${EPREFIX}}"
	doexe bit.so
}

multilib_src_install_all() {
	dodoc README
	dohtml -r doc/.
}
