# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/color-browser/color-browser-0.3-r1.ebuild,v 1.3 2014/03/16 11:57:11 ulm Exp $

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
