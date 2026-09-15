# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Colorize strings that represent colors inside Emacs buffers"
HOMEPAGE="https://elpa.gnu.org/packages/rainbow-mode.html"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

SITEFILE="50${PN}-gentoo.el"
