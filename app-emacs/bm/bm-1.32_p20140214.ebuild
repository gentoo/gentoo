# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Visible bookmarks in buffer"
HOMEPAGE="https://www.nongnu.org/bm/
	https://www.emacswiki.org/emacs/VisibleBookmarks"
# snapshot of https://github.com/joodland/bm.git
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${PN}"
ELISP_REMOVE="bm-tests.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
