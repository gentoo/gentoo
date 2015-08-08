# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Visible bookmarks in buffer"
HOMEPAGE="http://www.nongnu.org/bm/
	http://www.emacswiki.org/emacs/VisibleBookmarks"
# snapshot of https://github.com/joodland/bm.git
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

S="${WORKDIR}/${PN}"
ELISP_REMOVE="bm-tests.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
