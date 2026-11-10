# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Sort CSS buffer"
HOMEPAGE="https://www.emacswiki.org/emacs/css-sort-buffer.el"
# taken from https://www.emacswiki.org/emacs/download/${PN}.el
SRC_URI="https://distfiles.gentoo.org/pub/proj/emacs/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
