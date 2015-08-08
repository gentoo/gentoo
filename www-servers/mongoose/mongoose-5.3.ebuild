# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="easy to use web server"
SRC_URI="https://github.com/cesanta/${PN}/archive/${PV}.zip -> ${P}.zip"
HOMEPAGE="https://code.google.com/p/${PN}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux ~x86 ~arm-linux ~x86-linux"
IUSE="lua"

RDEPEND="lua? ( >=dev-lang/lua-5.2.3:5.2= )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${P}/examples

src_prepare() {
	if use lua ; then
		sed \
			-e "s|^#CFLAGS += -I\$(LUA) -L\$(LUA) -llua|CFLAGS += -I$($(tc-getPKG_CONFIG) --variable includedir lua5.2)/lua5.2 -L$($(tc-getPKG_CONFIG) --variable libdir lua5.2) -llua5.2|" \
			-i Makefile || die
	fi
	sed \
		-e 's|^CFLAGS = -W -Wall -I.. -pthread -g -pipe $(CFLAGS_EXTRA)|CFLAGS += -I.. -pthread $(LDFLAGS)|' \
		-e "s|g++ unit_test.c -Wall -W -pedantic -lssl|$(tc-getCC) unit_test.c -Wall -W -pedantic -lssl -pthread|" \
		-i Makefile || die
}

src_compile() {
	tc-export CC
	emake server
}

src_test() {
	emake u
}

src_install() {
	newbin "${S}/server" "${PN}"
	dodoc ../docs/{FAQ,LuaSqlite,Options,SSL,Usage}.md
}
