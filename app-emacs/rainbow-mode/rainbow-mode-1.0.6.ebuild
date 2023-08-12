# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Colorize strings that represent colors inside Emacs buffers"
HOMEPAGE="https://elpa.gnu.org/packages/rainbow-mode.html"
SRC_URI="https://elpa.gnu.org/packages/${P}.tar"

LICENSE="GPL-3+"
KEYWORDS="amd64 ~x86"
SLOT="0"

ELISP_REMOVE="${PN}-pkg.el"
SITEFILE="50${PN}-gentoo.el"
