# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/auto-complete/auto-complete-1.3.1.ebuild,v 1.2 2014/02/27 17:49:50 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Auto-complete package"
HOMEPAGE="http://cx4a.org/software/auto-complete/
	http://github.com/m2ym/auto-complete/"
SRC_URI="http://cx4a.org/pub/${PN}/${P}.tar.bz2"

LICENSE="GPL-3+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_ja"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	# install dictionaries
	insinto "${SITEETC}/${PN}"
	doins -r dict

	dodoc README.txt TODO.txt etc/test.txt
	cd doc
	dodoc index.txt manual.txt demo.txt changes.txt *.png
	if use linguas_ja; then
		dodoc index.ja.txt manual.ja.txt changes.ja.txt
	fi
}
