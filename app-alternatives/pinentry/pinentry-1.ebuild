# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"pinentry-curses:app-crypt/pinentry[ncurses]"
	"pinentry-gnome3:app-crypt/pinentry[gtk]"
	"pinentry-qt5:app-crypt/pinentry[qt5]"
	"pinentry-efl:app-crypt/pinentry[efl]"
	"pinentry-tty:app-crypt/pinentry"
)

inherit app-alternatives

DESCRIPTION="pinentry symlinks"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

src_install() {
	dosym $(get_alternative) /usr/bin/pinentry
}
