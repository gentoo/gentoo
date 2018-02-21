# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit elisp

DESCRIPTION="An improved interface to kill-ring"
HOMEPAGE="https://www.emacswiki.org/emacs/BrowseKillRing
	https://github.com/T-J-Teru/browse-kill-ring"
# taken from upstream git repo
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
