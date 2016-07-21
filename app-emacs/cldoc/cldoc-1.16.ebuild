# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Show Common Lisp operators and variables information in echo area"
HOMEPAGE="http://homepage1.nifty.com/bmonkey/lisp/index-en.html"
# taken from http://homepage1.nifty.com/bmonkey/emacs/elisp/cldoc.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="app-emacs/slime"

SITEFILE="50${PN}-gentoo.el"
