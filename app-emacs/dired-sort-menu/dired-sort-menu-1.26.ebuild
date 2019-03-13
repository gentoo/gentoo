# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit elisp

DESCRIPTION="Sort entries in Dired mode"
HOMEPAGE="https://www.emacswiki.org/emacs/DiredSortMenu"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

SITEFILE="50${PN}-gentoo.el"
