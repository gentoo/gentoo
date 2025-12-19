# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU readline wrapper"
HOMEPAGE="https://github.com/hanslub42/rlwrap"
SRC_URI="https://github.com/hanslub42/rlwrap/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 arm64 ~mips ~ppc ~riscv x86 ~x64-macos"
IUSE="debug"

# We always depend on dev-libs/libptytty as while it's technically optional
# upstream, the fallback code is 'crusty and for obsolete systems'.
RDEPEND="
	dev-libs/libptytty
	sys-libs/ncurses:=
	sys-libs/readline:=
"
DEPEND="${RDEPEND}"

src_configure() {
	# TODO: Python, Perl?
	# https://github.com/hanslub42/rlwrap#filters
	econf $(use_enable debug)
}
