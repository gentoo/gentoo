# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ALTERNATIVES=(
	"ncurses:app-crypt/pinentry[ncurses]"
	"gtk:app-crypt/pinentry[gtk]"
	"qt5:app-crypt/pinentry[qt5]"
	"efl:app-crypt/pinentry[efl]"
	"tty:app-crypt/pinentry"
)

inherit app-alternatives

DESCRIPTION="pinentry symlinks"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

src_install() {
	local alternative
	case $(get_alternative) in
		ncurses)
			alternative=curses
			;;
		gtk)
			alternative=gnome3
			;;
		*)
			alternative=$(get_alternative)
			;;
	esac
	dosym pinentry-${alternative} /usr/bin/pinentry
}
