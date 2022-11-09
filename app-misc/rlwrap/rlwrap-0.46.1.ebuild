# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GNU readline wrapper"
HOMEPAGE="https://github.com/hanslub42/rlwrap"
SRC_URI="https://github.com/hanslub42/rlwrap/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~mips ~ppc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug"

RDEPEND="
	sys-libs/ncurses:=
	sys-libs/readline:=
"
DEPEND="${RDEPEND}"

src_configure() {
	# TODO: Python, Perl?
	# https://github.com/hanslub42/rlwrap#filters
	econf $(use_enable debug)
}
