# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs unpacker

DESCRIPTION="A powerful and user-friendly console text editor"
HOMEPAGE="https://www.gnu.org/software/moe/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.lz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="
	$(unpacker_src_uri_depends)
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-1.12-respect-user-flags.patch )

src_configure() {
	tc-export CXX PKG_CONFIG
	default
}
