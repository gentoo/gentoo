# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
NEED_EMACS=26

inherit elisp

DESCRIPTION="Basic edit toolkit"
HOMEPAGE="https://www.emacswiki.org/emacs/basic-toolkit.el"
# taken from https://www.emacswiki.org/emacs/download/${PN}.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/windows
	app-emacs/cycle-buffer
	app-emacs/css-sort-buffer"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
