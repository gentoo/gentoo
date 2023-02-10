# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp autotools

DESCRIPTION="The Insidious Big Brother Database"
HOMEPAGE="https://savannah.nongnu.org/projects/bbdb/"
SRC_URI="https://git.savannah.nongnu.org/cgit/bbdb.git/snapshot/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.3"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="doc tex vm wanderlust"
RESTRICT="test" #631700

RDEPEND="vm? ( app-emacs/vm )
	wanderlust? ( app-emacs/wanderlust )"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/texinfo
	doc? ( virtual/texi2dvi )"
IDEPEND="tex? ( virtual/latex-base )"

SITEFILE="50${PN}-gentoo-3.2.el"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		"$(use_with vm vm-dir "${EPREFIX}${SITELISP}/vm")" \
		"$(use_with wanderlust wl-dir "${EPREFIX}${SITELISP}/wl")"
}

src_compile() {
	emake -C lisp
	emake -C doc info $(usev doc pdf)
}

src_install() {
	emake -C lisp DESTDIR="${D}" install
	emake -C doc DESTDIR="${D}" install-info $(usev doc install-pdf)
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc AUTHORS ChangeLog NEWS README TODO

	if use tex; then
		insinto "${TEXMF}"/tex/latex/${PN}
		doins tex/bbdb.sty
	fi
}

pkg_postinst() {
	elisp-site-regen
	use tex && texconfig rehash
}

pkg_postrm() {
	elisp-site-regen
	use tex && texconfig rehash
}
