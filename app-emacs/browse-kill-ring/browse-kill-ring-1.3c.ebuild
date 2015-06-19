# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/browse-kill-ring/browse-kill-ring-1.3c.ebuild,v 1.1 2011/12/04 23:35:32 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="An improved interface to kill-ring"
HOMEPAGE="http://www.emacswiki.org/emacs/BrowseKillRing
	https://github.com/T-J-Teru/browse-kill-ring"
# taken from upstream git repo
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
