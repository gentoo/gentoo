# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/thinks/thinks-1.9.ebuild,v 1.2 2014/02/13 21:00:54 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Insert text in a think bubble"
HOMEPAGE="http://www.davep.org/emacs/"
# taken from http://www.davep.org/emacs/${PN}.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
