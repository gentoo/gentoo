# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/sml-mode/sml-mode-6.1-r1.ebuild,v 1.5 2013/01/20 10:51:32 ago Exp $

EAPI=4

inherit elisp

DESCRIPTION="Emacs major mode for editing Standard ML"
HOMEPAGE="http://www.iro.umontreal.ca/~monnier/elisp/"
# taken from http://bzr.sv.gnu.org/r/emacs/elpa
SRC_URI="mirror://gentoo/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 ppc x86"

DEPEND="app-arch/xz-utils"

SITEFILE="50${PN}-gentoo-${PV}.el"

src_compile() {
	elisp-compile *.el || die
	elisp-make-autoload-file || die
}
