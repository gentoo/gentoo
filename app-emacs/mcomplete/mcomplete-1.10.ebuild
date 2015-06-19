# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/mcomplete/mcomplete-1.10.ebuild,v 1.1 2015/01/27 18:48:32 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="An improved interface to minibuffer completion"
HOMEPAGE="http://homepage1.nifty.com/bmonkey/emacs/index-en.html
	http://www.emacswiki.org/emacs/McompleteMode"
# taken from http://homepage1.nifty.com/bmonkey/emacs/elisp/mcomplete.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
