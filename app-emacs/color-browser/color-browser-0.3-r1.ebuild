# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="A utility for designing Emacs color themes"
HOMEPAGE="http://www.emacswiki.org/emacs/KahlilHodgson"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="app-emacs/color-theme"
RDEPEND="${DEPEND}"

ELISP_PATCHES="${PV}-gentoo.patch"
SITEFILE="60${PN}-gentoo.el"
