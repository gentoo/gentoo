# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="An Emacs major mode for editing XSL stylesheets and running XSL processes"
HOMEPAGE="http://www.menteith.com/wiki/xslide"
SRC_URI="mirror://sourceforge/xslide/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog NEWS README.TXT TODO"

src_compile() {
	emake EMACS=emacs
}
