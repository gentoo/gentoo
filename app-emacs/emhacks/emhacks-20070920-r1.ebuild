# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp

DESCRIPTION="Useful Emacs Lisp libraries, including gdiff, jjar, jmaker, swbuff, and tabbar"
HOMEPAGE="http://emhacks.sourceforge.net/"
# CVS snapshot
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="Changelog"

src_prepare() {
	# remove files included in Emacs>=22 or not useful on GNU/Linux
	# remove jsee #642588
	rm -r findstr* jsee* overlay-fix* recentf* ruler-mode* tree-widget* || die
	eapply_user
}
