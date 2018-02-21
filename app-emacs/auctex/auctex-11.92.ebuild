# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="Extensible package for writing and formatting TeX files in Emacs"
HOMEPAGE="https://www.gnu.org/software/auctex/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="preview-latex"

DEPEND="virtual/latex-base
	preview-latex? (
		app-text/dvipng
		app-text/ghostscript-gpl
	)"
RDEPEND="${DEPEND}"

TEXMF="/usr/share/texmf-site"

src_configure() {
	econf --with-emacs \
		--with-auto-dir="${EPREFIX}/var/lib/auctex" \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-packagelispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-packagedatadir="${EPREFIX}${SITEETC}/${PN}" \
		--with-texmf-dir="${EPREFIX}${TEXMF}" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-build-dir-test \
		$(use_enable preview-latex preview)
}

src_compile() {
	export VARTEXFONTS="${T}"/fonts
	emake
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el"
	if use preview-latex; then
		elisp-site-file-install "${FILESDIR}/60${PN}-gentoo.el"
	fi
	dodoc ChangeLog* CHANGES FAQ INSTALL PROBLEMS.preview README RELEASE TODO
}

pkg_postinst() {
	use preview-latex && texmf-update
	elisp-site-regen
}

pkg_postrm(){
	use preview-latex && texmf-update
	elisp-site-regen
}
