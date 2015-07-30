# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/lpeg/lpeg-0.12.2.ebuild,v 1.4 2015/07/30 15:07:16 ago Exp $

EAPI=5

inherit flag-o-matic toolchain-funcs eutils multilib

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="http://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="http://www.inf.puc-rio.br/~roberto/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ppc ppc64 sparc ~x86"
IUSE="debug doc"

RDEPEND=">=dev-lang/lua-5.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.12.1-makefile.patch
	use debug && append-cflags -DLPEG_DEBUG
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() {
	lua test.lua || die
}

src_install() {
	exeinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD lua)"
	doexe lpeg.so

	dodoc HISTORY

	use doc && dohtml *
}
