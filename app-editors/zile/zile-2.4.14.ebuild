# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Zile is a small Emacs clone"
HOMEPAGE="https://www.gnu.org/software/zile/"
SRC_URI="mirror://gnu/zile/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="acl test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/boehm-gc-7.2:=
	sys-libs/ncurses:0=
	acl? ( virtual/acl )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/perl )"

QA_AM_MAINTAINER_MODE=".*help2man.*" #450278

src_configure() {
	# --without-emacs to suppress tests for GNU Emacs #630652
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--without-emacs \
		--disable-valgrind-tests \
		$(use_enable acl) \
		CURSES_LIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
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

src_install() {
	emake DESTDIR="${D}" install

	# AUTHORS, FAQ, and NEWS are installed by the build system
	dodoc README THANKS

	# Zile should never install charset.alias (even on non-glibc arches)
	rm -f "${ED}"/usr/lib/charset.alias
}
