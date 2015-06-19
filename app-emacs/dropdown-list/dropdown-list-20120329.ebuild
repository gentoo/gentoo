# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/dropdown-list/dropdown-list-20120329.ebuild,v 1.2 2015/01/27 18:02:45 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Drop-down menu interface"
HOMEPAGE="http://www.emacswiki.org/emacs/dropdown-list.el"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.el.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

ELISP_PATCHES="${PN}-20090814-selection-face.patch"
SITEFILE="50${PN}-gentoo.el"
