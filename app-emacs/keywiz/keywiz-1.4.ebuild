# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/keywiz/keywiz-1.4.ebuild,v 1.8 2014/02/15 10:45:06 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Emacs key sequence quiz"
HOMEPAGE="http://www.phys.au.dk/~harder/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
