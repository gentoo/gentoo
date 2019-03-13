# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Outline mode extensions for Emacs"
HOMEPAGE="https://github.com/tj64/outline-magic
	https://www.emacswiki.org/emacs/OutlineMagic"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
