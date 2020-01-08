# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An Emacs major mode for editing XSL stylesheets and running XSL processes"
HOMEPAGE="https://sourceforge.net/projects/xslide/"
SRC_URI="mirror://sourceforge/xslide/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog NEWS README.TXT TODO"

src_compile() {
	default
}
