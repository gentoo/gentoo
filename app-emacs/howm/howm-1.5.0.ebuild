# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Note-taking tool on Emacs"
HOMEPAGE="https://howm.sourceforge.jp/"
SRC_URI="http://howm.sourceforge.jp/a/${P}.tar.gz"

LICENSE="GPL-1+ GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

SITEFILE="50${PN}-gentoo.el"

src_configure() {
	econf \
		--with-emacs \
		--with-lispdir="${SITELISP}" \
		EMACS="${EMACS} --no-site-file"
}

src_compile() {
	emake -j1 EMACS="${EMACS} --no-site-file" </dev/null
}

src_install() {
	emake -j1 DESTDIR="${D}" install </dev/null
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc ChangeLog
}
