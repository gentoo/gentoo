# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Battle-bots for Emacs!"
HOMEPAGE="https://www.emacswiki.org/emacs/EmacsRobots"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

ELISP_PATCHES="${P}-fix-interactive.patch"
SITEFILE="50${PN}-gentoo.el"
