# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Jonathan's Own Version of Emacs, a light emacs-like editor without LISP bindings"
HOMEPAGE="https://github.com/jonmacs/jove"
SRC_URI="https://github.com/jonmacs/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="JOVE"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_compile() {
	tc-export CC

	myopts=(
		JOVEHOME="${EPREFIX}/usr" \
		JMANDIR="${EPREFIX}/usr/share/man/man1" \
		JDOCDIR="${EPREFIX}/usr/share/doc/${PF}" \
		OPTFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		LDLIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)" \
		SYSDEFS="-DLinux" \
		$(usev !doc FREFDOCS="")
	)
	emake "${myopts[@]}"
}

src_install() {
	# The Makefile triggers a rebuild if any of the options have changed
	# (see recipe for keys.c). So we must pass identical options even if
	# they're not needed for installation.
	emake "${myopts[@]}" DESTDIR="${D}" install

	keepdir /var/lib/jove/preserve
	dodoc README
}
