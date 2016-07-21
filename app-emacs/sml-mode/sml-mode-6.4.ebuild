# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
NEED_EMACS=24

inherit elisp

DESCRIPTION="Emacs major mode for editing Standard ML"
HOMEPAGE="http://www.iro.umontreal.ca/~monnier/elisp/"
# taken from https://elpa.gnu.org/packages/${P}.el
SRC_URI="mirror://gentoo/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"

SITEFILE="50${PN}-gentoo-6.1.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
