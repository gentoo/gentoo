# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Text file backspacing and ANSI SGR as faces"
HOMEPAGE="https://user42.tuxfamily.org/tty-format/index.html
	https://www.emacswiki.org/emacs/TtyFormat"
# taken from https://download.tuxfamily.org/user42/tty-format.el"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
