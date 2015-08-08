# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils readme.gentoo elisp

DESCRIPTION="Blogging in Emacs"
HOMEPAGE="http://billstclair.com/blogmax/index.html"
# taken from http://billstclair.com/blogmax.zip
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.zip"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	rm *.elc gpl.txt || die
	edos2unix *.{el,html,inc,ini,tmpl,txt,xml} docs/*.{html,txt}
}

src_compile() {
	elisp-compile blogmax.el
}

src_install() {
	elisp-install ${PN} blogmax.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	DOC_CONTENTS="To get started with BlogMax, use the example site file
		from /usr/share/doc/${PF}/example as a template for your own blog."
	readme.gentoo_create_doc

	dodoc README
	dodoc -r docs
	docinto example
	dodoc *.{html,inc,ini,png,tmpl,txt,xml}
}
