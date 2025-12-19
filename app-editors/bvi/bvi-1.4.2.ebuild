# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="Display-oriented editor for binary files, based on the vi texteditor"
HOMEPAGE="https://bvi.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.src.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 ~riscv x86"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

src_configure() {
	append-cflags -DANSI -std=gnu89
	default
}
