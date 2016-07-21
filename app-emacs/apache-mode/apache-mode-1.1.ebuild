# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="Major mode for editing Apache configuration files"
HOMEPAGE="http://www.keelhaul.me.uk/linux/#apachemode"
SRC_URI="mirror://gentoo/${P}.el.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
