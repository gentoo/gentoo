# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp latex-package

DESCRIPTION="Extended support for writing, formatting and using (La)TeX, Texinfo and BibTeX files"
HOMEPAGE="http://www.gnu.org/software/auctex/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="preview-latex"

DEPEND="virtual/latex-base
	preview-latex? (
		app-text/dvipng
		app-text/ghostscript-gpl
	)"
RDEPEND="${DEPEND}"

ELISP_PATCHES="${P}-jit-lock.patch"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	elisp_src_prepare
}

src_configure() {
	EMACS_NAME=emacs EMACS_FLAVOR=emacs econf --disable-build-dir-test \
		--with-auto-dir="${EPREFIX}/var/lib/auctex" \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-packagelispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-packagedatadir="${EPREFIX}${SITEETC}/${PN}" \
		--with-texmf-dir="${EPREFIX}${TEXMF}" \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable preview-latex preview)
}

src_compile() {
	export VARTEXFONTS="${T}"/fonts
	emake
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el" || die
	if use preview-latex; then
		elisp-site-file-install "${FILESDIR}/60${PN}-gentoo.el" || die
	fi
	dodoc ChangeLog CHANGES FAQ INSTALL README RELEASE TODO
}

pkg_postinst() {
	# rebuild TeX-inputfiles-database
	use preview-latex && latex-package_pkg_postinst
	elisp-site-regen
}

pkg_postrm(){
	use preview-latex && latex-package_pkg_postrm
	elisp-site-regen
}
