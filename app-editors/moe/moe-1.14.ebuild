# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs unpacker

DESCRIPTION="Powerful and user-friendly console text editor"
HOMEPAGE="https://www.gnu.org/software/moe/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.lz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~riscv ~x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="
	$(unpacker_src_uri_depends)
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-respect-user-flags.patch )

src_configure() {
	tc-export CXX PKG_CONFIG
	default
}
