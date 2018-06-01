# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Major mode for color moccur"
HOMEPAGE="http://www.bookshelf.jp/
	https://www.emacswiki.org/emacs/SearchBuffers"
# taken from http://www.bookshelf.jp/elc/color-moccur.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
