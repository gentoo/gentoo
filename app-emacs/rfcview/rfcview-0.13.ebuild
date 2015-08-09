# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="An Emacs mode that reformats IETF RFCs for display"
HOMEPAGE="http://www.loveshack.ukfsn.org/emacs/
	http://www.emacswiki.org/emacs/RfcView"
# taken from http://www.loveshack.ukfsn.org/emacs/${PN}.el
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
