# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
NEED_EMACS=24

inherit elisp

DESCRIPTION="Queue data structure"
HOMEPAGE="https://elpa.gnu.org/packages/queue.html"
SRC_URI="https://dev.gentoo.org/~matthew/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
