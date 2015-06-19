# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/toluapp/toluapp-1.0.93.ebuild,v 1.3 2014/08/10 20:42:23 slyfox Exp $

EAPI="2"

inherit toolchain-funcs

MY_P=${P/pp/++}

DESCRIPTION="A tool to integrate C/C++ code with Lua"
HOMEPAGE="http://www.codenix.com/~tolua/"
SRC_URI="http://www.codenix.com/~tolua/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-lang/lua-5.1.1[deprecated]"
DEPEND="${RDEPEND}
	dev-util/scons"

S=${WORKDIR}/${MY_P}

src_compile() {
	echo "## BEGIN gentoo.py

LIBS = ['lua', 'dl', 'm']

## END gentoo.py" > ${S}/custom.py

	scons \
		CC="$(tc-getCC)" \
		CCFLAGS="${CFLAGS} -ansi -Wall" \
		CXX="$(tc-getCXX)" \
		LINK="$(tc-getCC)" \
		LINKFLAGS="${LDFLAGS}" \
		shared=1 || die "scons failed"
}

src_install() {
	dobin bin/tolua++ || die "dobin failed"
#	dobin bin/tolua++_bootstrap || die "dobin failed"
#	dolib.a lib/libtolua++_static.a || die "dolib.a failed"
	dolib.so lib/libtolua++.so || die "dolib.so failed"
	insinto /usr/include
	doins include/tolua++.h || die "doins failed"
	dodoc README
	dohtml doc/*
}
