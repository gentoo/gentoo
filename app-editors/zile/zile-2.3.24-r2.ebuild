# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Zile is a small Emacs clone"
HOMEPAGE="https://www.gnu.org/software/zile/"
SRC_URI="mirror://gnu/zile/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test valgrind"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( valgrind? ( dev-util/valgrind ) )"

PATCHES=("${FILESDIR}"/${P}-{userhome,gets}.patch)

src_configure() {
	# --without-emacs to suppress tests for GNU Emacs #630652
	econf \
		--without-emacs \
		$(use test && use_with valgrind || echo "--without-valgrind") \
		CURSES_LIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_test() {
	if tput cup 0 0 >/dev/null || tput cuu1 >/dev/null; then
		# We have a sane terminal that can move the cursor
		emake check
	else
		ewarn "Terminal type \"${TERM}\" is too stupid to run zile"
		ewarn "Running the tests with TERM=vt100 instead"
		TERM=vt100 emake check
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	# FAQ is installed by the build system in /usr/share/zile
	dodoc AUTHORS BUGS NEWS README THANKS

	# Zile should never install charset.alias (even on non-glibc arches)
	rm -f "${ED}"/usr/lib/charset.alias
}
