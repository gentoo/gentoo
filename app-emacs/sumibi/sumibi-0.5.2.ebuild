# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit elisp

DESCRIPTION="Statistical Japanese input method using the Internet as a large corpus"
HOMEPAGE="http://www.sumibi.org/"
SRC_URI="mirror://sourceforge.jp/sumibi/17176/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el

src_compile() {
	cd client/elisp
	elisp-compile *.el || die "elisp-compile failed"
}

src_install() {
	cd client/elisp
	elisp-install ${PN} *.{el,elc} || die "elisp-install failed"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
		|| die "elisp-site-file-install failed"

	cd "${S}"
	dodoc README CREDITS CHANGELOG
}
