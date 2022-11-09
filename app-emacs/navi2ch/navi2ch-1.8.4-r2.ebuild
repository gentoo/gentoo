# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="A navigator for the Japanese textboard 2ch"
HOMEPAGE="http://navi2ch.sourceforge.net/"
SRC_URI="mirror://sourceforge/navi2ch/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		--with-icondir="${EPREFIX}${SITEETC}/${PN}"
}

src_compile() {
	default
}

src_install() {
	emake DESTDIR="${D}" install
	elisp-install ${PN} contrib/*.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog* NEWS README TODO
	newdoc contrib/README README.contrib

	DOC_CONTENTS="Please add the following lines to your ~/.emacs file:
		\n\nIf you use mona-font:
		\n\t(setq navi2ch-mona-enable t)
		\nIf you use izonmoji-mode:
		\n\t(require 'izonmoji-mode)
		\n\t(add-hook 'navi2ch-bm-mode-hook 'izonmoji-mode-on)
		\n\t(add-hook 'navi2ch-article-mode-hook 'izonmoji-mode-on)
		\n\t(add-hook 'navi2ch-popup-article-mode-hook 'izonmoji-mode-on)"
	readme.gentoo_create_doc
}
