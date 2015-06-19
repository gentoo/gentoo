# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/bubblet/bubblet-0.74-r1.ebuild,v 1.5 2014/02/12 09:01:07 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="A bubble-popping game"
HOMEPAGE="http://web.archive.org/web/20051217154122/www.gelatinous.com/pld/bubblet.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

SITEFILE="50${PN}-gentoo.el"
