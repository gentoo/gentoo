# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/binclock/binclock-1.7-r1.ebuild,v 1.7 2012/09/08 17:55:42 ulm Exp $

EAPI=4

inherit elisp

DESCRIPTION="Display the current time using a binary clock"
HOMEPAGE="http://www.davep.org/emacs/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
