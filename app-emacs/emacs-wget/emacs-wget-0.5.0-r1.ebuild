# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp

DESCRIPTION="Wget interface for Emacs"
HOMEPAGE="https://www.emacswiki.org/emacs/EmacsWget"
SRC_URI="http://pop-club.hp.infoseek.co.jp/emacs/emacs-wget/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"
IUSE="l10n_ja"

RDEPEND=">=net-misc/wget-1.8.2"

ELISP_REMOVE="lpath.el"
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install
	dodoc ChangeLog README USAGE
	use l10n_ja && dodoc README.ja USAGE.ja
}
