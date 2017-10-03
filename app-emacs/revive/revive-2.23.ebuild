# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="Resume Emacs"
HOMEPAGE="http://www.gentei.org/~yuuji/software/"
# taken from http://www.gentei.org/~yuuji/software/euc/revive.el
SRC_URI="https://github.com/gavv/distfiles/raw/master/${P}.el.xz"

LICENSE="yuuji"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
