# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="24"

inherit elisp

DESCRIPTION="The Garbage Collector Magic Hack"
HOMEPAGE="https://elpa.gnu.org/packages/gcmh.html"
SRC_URI="https://dev.gentoo.org/~arsen/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
ELISP_REMOVE="${PN}-pkg.el"
