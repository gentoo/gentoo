# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cgdb/cgdb-0.6.7.ebuild,v 1.6 2015/02/04 16:15:13 haubi Exp $

EAPI="4"

DESCRIPTION="A curses front-end for GDB, the GNU debugger"
HOMEPAGE="http://cgdb.github.io/"
SRC_URI="http://cgdb.me/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="sys-libs/ncurses
	>=sys-libs/readline-5.1-r2"
RDEPEND="${DEPEND}
	sys-devel/gdb"
