# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools elisp-common toolchain-funcs

DESCRIPTION="Interactively examine a C program"
HOMEPAGE="https://cscope.sourceforge.net/"
SRC_URI="mirror://sourceforge/cscope/${P}.tar.gz"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="emacs"

RDEPEND=">=sys-libs/ncurses-5.2:0=
	emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/flex
	virtual/pkgconfig
	app-alternatives/yacc"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	eapply "${FILESDIR}/${PN}-15.7a-ocs-sysdir.patch" #269305
	eapply "${FILESDIR}/${PN}-15.9-pkgconfig.patch"
	eapply "${FILESDIR}/${PN}-15.9-emacs-27.patch"
	eapply_user
	mv configure.{in,ac} || die
	eautoreconf		  # prevent maintainer mode later on
}

src_configure() {
	econf --with-ncurses="${EPREFIX}"/usr
}

src_compile() {
	emake CURSES_LIBS="$("$(tc-getPKG_CONFIG)" --libs ncurses)"
	if use emacs; then
		cd "${S}"/contrib/xcscope || die
		elisp-compile *.el
	fi
}

src_install() {
	default

	if use emacs; then
		cd "${S}"/contrib/xcscope || die
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
		dobin cscope-indexer
	fi

	cd "${S}"/contrib/webcscope || die
	docinto webcscope
	dodoc INSTALL TODO cgi-lib.pl cscope hilite.c
	docinto webcscope/icons
	dodoc icons/*.gif
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
