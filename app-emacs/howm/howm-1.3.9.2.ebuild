# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="Note-taking tool on Emacs"
HOMEPAGE="http://howm.sourceforge.jp/"
SRC_URI="http://howm.sourceforge.jp/a/${P}.tar.gz"

LICENSE="GPL-1+ GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf --with-docdir="${EPREFIX}/usr/share/doc/${PF}"
}

src_compile() {
	emake -j1 </dev/null
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LISPDIR="${EPREFIX}${SITELISP}/${PN}" \
		install </dev/null
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
	dodoc ChangeLog
}

pkg_postinst() {
	elisp-site-regen
	elog "site-gentoo.el does no longer define global keybindings for howm."
	elog "Add the following line to ~/.emacs for the previous behaviour:"
	elog "  (require 'howm)"
}
