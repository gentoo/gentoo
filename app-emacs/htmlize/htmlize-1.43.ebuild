# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/htmlize/htmlize-1.43.ebuild,v 1.5 2012/12/01 19:48:24 armin76 Exp $

EAPI=4

inherit elisp

DESCRIPTION="HTML-ize font-lock buffers in Emacs"
HOMEPAGE="http://emacswiki.org/emacs/Htmlize
	http://fly.srk.fer.hr/~hniksic/emacs/"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
