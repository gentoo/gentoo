# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit elisp

DESCRIPTION="Emacs thumbnail previewer for image files"
HOMEPAGE="https://www.emacswiki.org/emacs/ThumbsMode"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="virtual/imagemagick-tools"

SITEFILE="50${PN}-gentoo.el"
