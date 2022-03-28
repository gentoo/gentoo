# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
VALA_MIN_API_VERSION=0.52

inherit toolchain-funcs vala

DESCRIPTION="Zile is a small Emacs clone"
HOMEPAGE="https://www.gnu.org/software/zile/"
SRC_URI="mirror://gnu/zile/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="dev-libs/glib:2
	dev-libs/libgee:0.8=
	sys-libs/ncurses:0="

DEPEND="${RDEPEND}"

BDEPEND="dev-lang/perl
	sys-apps/help2man
	virtual/pkgconfig
	$(vala_depend)"

# AUTHORS, FAQ, and NEWS are installed by the build system
DOCS="README THANKS"

QA_AM_MAINTAINER_MODE=".*help2man.*" #450278

src_prepare() {
	default
	vala_setup
	rm *_vala.stamp || die
}

src_configure() {
	econf CURSES_LIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
}

src_test() {
	if tput cup 0 0 >/dev/null || tput cuu1 >/dev/null; then
		# We have a sane terminal that can move the cursor
		emake check
	else
		ewarn "Terminal type \"${TERM}\" is too stupid to run zile"
		ewarn "Running the tests with unset TERM instead"
		( unset TERM; emake check )
	fi
}
