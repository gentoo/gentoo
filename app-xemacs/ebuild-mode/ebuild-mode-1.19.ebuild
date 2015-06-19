# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/ebuild-mode/ebuild-mode-1.19.ebuild,v 1.2 2014/08/10 18:51:26 slyfox Exp $

inherit xemacs-elisp eutils

MY_PN="gentoo-syntax"
DESCRIPTION="An Emacs mode for editing ebuilds and other Gentoo specific files"
HOMEPAGE="http://www.gentoo.org/proj/en/lisp/emacs/index.xml"
SRC_URI="mirror://gentoo/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=app-editors/xemacs-21.4.20-r5
	app-xemacs/sh-script"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_compile() {
	${XEMACS_BATCH_CLEAN} -eval "(add-to-list 'load-path \".\")" \
		-f batch-byte-compile gentoo-syntax.el || die
	xemacs-elisp-make-autoload-file *.el || die
}
