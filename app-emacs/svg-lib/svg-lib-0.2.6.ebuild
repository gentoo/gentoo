# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="27.1"
inherit elisp

DESCRIPTION="SVG tags, progress bars & icons"
HOMEPAGE="https://github.com/rougier/svg-lib"
SRC_URI="https://dev.gentoo.org/~arsen/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"
