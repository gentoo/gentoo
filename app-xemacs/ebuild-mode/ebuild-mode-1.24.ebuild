# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xemacs-elisp

DESCRIPTION="Emacs modes for editing ebuilds and other Gentoo specific files"
HOMEPAGE="https://www.gentoo.org/proj/en/lisp/emacs/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=app-editors/xemacs-21.4.20-r5
	app-xemacs/sh-script"
DEPEND="${RDEPEND}"

src_compile() {
	${XEMACS_BATCH_CLEAN} -eval "(add-to-list 'load-path \".\")" \
		-f batch-byte-compile ebuild-mode.el gentoo-newsitem-mode.el || die
	xemacs-elisp-make-autoload-file *.el || die
}
