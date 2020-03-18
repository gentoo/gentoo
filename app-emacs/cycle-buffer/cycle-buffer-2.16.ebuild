# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="Select buffer by cycling through"
HOMEPAGE="https://www.emacswiki.org/emacs/cycle-buffer.el"
# taken from https://www.emacswiki.org/emacs/download/cycle-buffer.el
SRC_URI="https://github.com/gavv/distfiles/raw/master/${P}.el.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el
	elisp-make-autoload-file
}
