# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Resume Emacs"
HOMEPAGE="https://www.gentei.org/~yuuji/software/"
# taken from https://www.gentei.org/~yuuji/software/euc/revive.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo-${PV}.el"
