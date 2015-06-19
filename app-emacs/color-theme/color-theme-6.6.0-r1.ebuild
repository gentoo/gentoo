# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/color-theme/color-theme-6.6.0-r1.ebuild,v 1.9 2014/06/01 10:39:50 ulm Exp $

EAPI=5

inherit readme.gentoo elisp

DESCRIPTION="Install color themes (includes many themes and allows you to share your own with the world)"
HOMEPAGE="http://www.nongnu.org/color-theme/"
SRC_URI="http://download.savannah.gnu.org/releases-noredirect/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"

ELISP_PATCHES="${P}-replace-in-string.patch"
ELISP_REMOVE="color-theme-autoloads.*"
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-install ${PN} *.el *.elc
	elisp-install ${PN}/themes themes/*.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc AUTHORS BUGS ChangeLog README

	DOC_CONTENTS="To use color-theme non-interactively, initialise it
		in your ~/.emacs file as in the following example (which is
		for the \"Blue Sea\" theme):
		\n
		\n(color-theme-initialize)
		\n(color-theme-blue-sea)"
	readme.gentoo_create_doc
}
