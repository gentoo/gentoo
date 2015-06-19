# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/stripes/stripes-0.2-r1.ebuild,v 1.6 2015/01/27 19:30:44 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="An Emacs mode which highlights every even line with an alternative background color"
HOMEPAGE="http://www.emacswiki.org/emacs/StripesMode"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 x86"

SITEFILE="50${PN}-gentoo.el"
