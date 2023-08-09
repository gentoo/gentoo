# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Display-oriented editor for binary files, based on the vi texteditor"
HOMEPAGE="http://bvi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.src.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~ppc ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

src_configure() {
	append-cflags -DANSI -std=gnu89
	default
}
