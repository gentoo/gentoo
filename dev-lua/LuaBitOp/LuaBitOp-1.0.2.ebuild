# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/LuaBitOp/LuaBitOp-1.0.2.ebuild,v 1.6 2014/12/09 09:52:22 jer Exp $

EAPI="5"
inherit toolchain-funcs

DESCRIPTION="Bit Operations Library for the Lua Programming Language"
HOMEPAGE="http://bitop.luajit.org"
SRC_URI="http://bitop.luajit.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips x86"
IUSE=""

RDEPEND="dev-lang/lua"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile()
{
	emake CC="$(tc-getCC)" INCLUDES= CCOPT=
}

src_install()
{
	exeinto "$(pkg-config --variable INSTALL_CMOD lua)"
	doexe bit.so

	dodoc README
	dohtml -r doc/*
}
