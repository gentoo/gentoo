# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION='Composing and deciphering C (or C++) declarations or casts, aka "gibberish."'
HOMEPAGE="https://github.com/paul-j-lucas/cdecl"
SRC_URI="https://github.com/paul-j-lucas/cdecl/releases/download/${P}/${P}.tar.gz -> ${P}.release.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="debug readline ncurses"

DEPEND="
	ncurses? ( sys-libs/ncurses:= )
	readline? ( sys-libs/readline:= )
"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_with readline) \
		$(use_enable ncurses term-size) \
		$(use_enable debug bison-debug) \
		$(use_enable debug flex-debug)
}
