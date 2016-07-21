# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Maintain a local Wiki using Emacs-friendly markup"
HOMEPAGE="http://www.mwolson.org/projects/EmacsWiki.html
	http://www.emacswiki.org/emacs/EmacsWikiMode"
SRC_URI="http://www.mwolson.org/static/dist/emacs-wiki/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="app-emacs/htmlize
	app-emacs/httpd"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# These will be made part of the emacs-wiki installation until
	# they are packaged separately
	mv "${S}"/contrib/{update-remote,cgi}.el "${S}"/ || die
}

src_compile() {
	elisp-compile *.el
	makeinfo emacs-wiki.texi || die "makeinfo failed"
}

src_install() {
	elisp-install ${PN} *.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	doinfo *.info*
	dodoc README ChangeLog*
	docinto examples
	dodoc examples/default.css
}
