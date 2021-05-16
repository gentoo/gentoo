# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Visible bookmarks in buffer"
HOMEPAGE="http://joodland.github.io/bm/
	https://www.emacswiki.org/emacs/VisibleBookmarks"
SRC_URI="https://github.com/joodland/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"

ELISP_REMOVE="bm-tests.el"
SITEFILE="50${PN}-gentoo.el"
DOCS="README.md"
