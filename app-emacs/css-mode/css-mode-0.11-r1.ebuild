# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/css-mode/css-mode-0.11-r1.ebuild,v 1.5 2015/02/23 11:01:08 ago Exp $

EAPI=5

inherit elisp

DESCRIPTION="A major mode for editing Cascading Style Sheets (CSS)"
HOMEPAGE="http://www.garshol.priv.no/download/software/css-mode/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"

ELISP_PATCHES="${P}-no-compat-kbd.patch"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare
	# Fix documentation
	sed -i -e 's,HREF="/visuals/standard.css",HREF="standard.css",' doco.html
}

src_install() {
	elisp_src_install
	dohtml -A css doco.html standard.css
}
