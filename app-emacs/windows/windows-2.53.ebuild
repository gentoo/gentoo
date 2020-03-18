# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Window manager for GNU Emacs"
HOMEPAGE="https://www.gentei.org/~yuuji/software/"
# taken from https://www.gentei.org/~yuuji/software/euc/${PN}.el
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-emacs/revive"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
