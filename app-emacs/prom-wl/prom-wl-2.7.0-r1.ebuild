# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit elisp

DESCRIPTION="Procmail reader for Wanderlust"
HOMEPAGE="http://www.h6.dion.ne.jp/~nytheta/software/prom-wl.html"
SRC_URI="http://www.h6.dion.ne.jp/~nytheta/software/pub/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-emacs/wanderlust"

SITEFILE=50${PN}-gentoo.el
DOCS="prom-wl-usage.jis"
