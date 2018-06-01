# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="An Emacs mode that alternates the background color of lines"
HOMEPAGE="https://www.emacswiki.org/emacs/StripesMode"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
