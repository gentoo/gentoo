# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Use templates, decorate comments, auto-update buffers"
HOMEPAGE="http://emacs-template.sourceforge.net/"
SRC_URI="mirror://sourceforge/emacs-template/${P}.tar.gz"

LICENSE="GPL-2+ Texinfo-manual"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-install ${PN} *.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	insinto "${SITEETC}/${PN}"
	doins -r templates
	doinfo template.info
}
