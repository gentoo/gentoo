# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/flashcard/flashcard-2.3.3.ebuild,v 1.6 2014/02/15 11:25:32 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="An Emacs Lisp package for drilling on questions and answers"
HOMEPAGE="http://ichi2.net/flashcard/
	http://www.emacswiki.org/emacs/FlashCard"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

SITEFILE="50${PN}-gentoo.el"
