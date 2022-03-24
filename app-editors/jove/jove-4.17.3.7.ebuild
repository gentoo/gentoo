# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Jonathan's Own Version of Emacs, a light emacs-like editor without LISP bindings"
HOMEPAGE="https://github.com/jonmacs/jove"
SRC_URI="https://github.com/jonmacs/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="JOVE"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	tc-export CC

	emake \
		JOVEHOME="${EPREFIX}/usr" \
		JMANDIR="${EPREFIX}/usr/share/man/man1" \
		OPTFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		SYSDEFS="-DLinux" \
		TERMCAPLIB="$("$(tc-getPKG_CONFIG)" --libs ncurses)"

	if use doc; then
		# Full manual (*not* man page)
		emake doc/jove.man
	fi
}

src_install() {
	emake \
		JOVEHOME="${EPREFIX}/usr" \
		JMANDIR="${EPREFIX}/usr/share/man/man1" \
		DESTDIR="${D}" \
		install
	keepdir /var/lib/jove/preserve

	dodoc README
	if use doc; then
		dodoc doc/jove.man
	fi
}
