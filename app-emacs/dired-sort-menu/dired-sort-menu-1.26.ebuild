# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/dired-sort-menu/dired-sort-menu-1.26.ebuild,v 1.6 2014/02/23 10:09:34 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Sort entries in Dired mode"
HOMEPAGE="http://centaur.maths.qmw.ac.uk/Emacs/
	http://www.emacswiki.org/emacs/DiredSortMenu"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"

SITEFILE="50${PN}-gentoo.el"
