# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/paredit/paredit-23-r1.ebuild,v 1.1 2014/02/18 13:13:08 ulm Exp $

EAPI=5

inherit elisp

DESCRIPTION="Minor mode for performing structured editing of S-expressions"
HOMEPAGE="http://mumble.net/~campbell/emacs/
	http://www.emacswiki.org/emacs/ParEdit"
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install
	dohtml *.html
}
