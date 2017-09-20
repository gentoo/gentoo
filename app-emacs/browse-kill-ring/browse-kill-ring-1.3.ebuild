# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit elisp

DESCRIPTION="An improved interface to kill-ring"
HOMEPAGE="https://www.emacswiki.org/emacs/BrowseKillRing
	https://github.com/todesschaf/browse-kill-ring"
# taken from http://www.todesschaf.org/files/browse-kill-ring.el
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
