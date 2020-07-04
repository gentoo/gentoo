# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Smart line-wrapping with wrap-prefix"
HOMEPAGE="https://elpa.gnu.org/packages/adaptive-wrap.html"
# taken from https://elpa.gnu.org/packages/${P}.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
