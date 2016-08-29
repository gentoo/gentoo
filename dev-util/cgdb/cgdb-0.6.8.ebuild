# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib-minimal

DESCRIPTION="A curses front-end for GDB, the GNU debugger"
HOMEPAGE="http://cgdb.github.io/"
SRC_URI="https://github.com/cgdb/cgdb/archive/v${PV}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}/${P}"

DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0="

RDEPEND="
	${DEPEND}
	sys-devel/gdb"

src_prepare() {
	default
	./autogen.sh || die
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf
}

src_compile() {
	multilib-minimal_src_compile
}

src_install() {
	multilib-minimal_src_install
	dodoc AUTHORS ChangeLog INSTALL NEWS README.md TODO
}
