# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/emacs-wget/emacs-wget-0.5.0-r1.ebuild,v 1.6 2014/04/20 11:20:23 ago Exp $

EAPI=5

inherit elisp

DESCRIPTION="Wget interface for Emacs"
HOMEPAGE="http://www.emacswiki.org/emacs/EmacsWget"
SRC_URI="http://pop-club.hp.infoseek.co.jp/emacs/emacs-wget/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE="linguas_ja"

RDEPEND=">=net-misc/wget-1.8.2"

ELISP_REMOVE="lpath.el"
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install
	dodoc ChangeLog README USAGE
	use linguas_ja && dodoc README.ja USAGE.ja
}
