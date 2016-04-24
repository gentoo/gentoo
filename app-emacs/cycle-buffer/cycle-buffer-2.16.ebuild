# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit elisp

DESCRIPTION="Select buffer by cycling through"
HOMEPAGE="http://www.emacswiki.org/emacs/cycle-buffer.el"
# taken from https://www.emacswiki.org/emacs/download/cycle-buffer.el
SRC_URI="https://enise.org/users/victor/share/distfiles/${P}.el.xz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el || die
	elisp-make-autoload-file || die
}
