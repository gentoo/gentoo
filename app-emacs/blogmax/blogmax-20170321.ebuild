# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp eutils readme.gentoo-r1

DESCRIPTION="Blogging in Emacs"
HOMEPAGE="https://billstclair.com/blogmax/index.html"
# snapshot from https://github.com/billstclair/BlogMax
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

S="${WORKDIR}/${PN}"
ELISP_REMOVE="*.elc gpl.txt"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	edos2unix *.{el,html,inc,ini,tmpl,txt,xml} docs/*.{html,txt}
	elisp_src_prepare
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
