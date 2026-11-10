# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="An Emacs mode that reformats IETF RFCs for display"
HOMEPAGE="http://www.loveshack.ukfsn.org/emacs/
	https://www.emacswiki.org/emacs/RfcView"
# taken from http://www.loveshack.ukfsn.org/emacs/${PN}.el
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
