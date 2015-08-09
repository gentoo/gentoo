# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp

DESCRIPTION="Useful Emacs Lisp libraries, including gdiff, jjar, jmaker, swbuff, and tabbar"
HOMEPAGE="http://emhacks.sourceforge.net/"
# CVS snapshot
SRC_URI="http://dev.gentoo.org/~ulm/distfiles/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jde"

DEPEND="jde? ( app-emacs/jde )"
RDEPEND="${DEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	# remove files included in Emacs>=22 or not useful on GNU/Linux
	rm -r findstr* overlay-fix* recentf* ruler-mode* tree-widget* || die
	# this requires jde and cedet, not everyone may want it
	use jde || rm jsee.el || die
}

src_install() {
	elisp-install ${PN} *.el *.elc

	cp "${FILESDIR}/${SITEFILE}" "${T}"
	use jde || sed -i -e '/;; jsee/,$d' "${T}/${SITEFILE}"
	elisp-site-file-install "${T}/${SITEFILE}"

	dodoc Changelog
}
