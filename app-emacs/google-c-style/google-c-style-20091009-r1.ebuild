# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/google-c-style/google-c-style-20091009-r1.ebuild,v 1.4 2011/11/11 22:04:44 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="Provides the google C/C++ coding style"
HOMEPAGE="http://code.google.com/p/google-styleguide/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}"
SITEFILE="50${PN}-gentoo.el"

pkg_postinst() {
	elisp-site-regen

	elog "Example usage (~/.emacs):"
	elog "  (add-hook 'c-mode-common-hook 'google-set-c-style)"
	elog "  (add-hook 'c-mode-common-hook 'google-make-newline-indent)"
}
