# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/twittering-mode/twittering-mode-9999.ebuild,v 1.4 2014/08/10 17:45:04 slyfox Exp $

EAPI=4

inherit elisp elisp-common eutils

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://github.com/hayamiz/twittering-mode.git"
	inherit git-2
	SRC_URI=""
	KEYWORDS=""
	IUSE="doc"
else
	SRC_URI="mirror://sourceforge/twmode/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="test"
	IUSE=""
fi

DESCRIPTION="Emacs major mode for Twitter"
HOMEPAGE="http://twmode.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="app-crypt/gnupg"

src_compile() {
	elisp-compile twittering-mode.el || die
	[ "${PV}" = "9999" ] && use doc && emake -C doc/manual
}

src_test() {
	emake check
}

src_install() {
	[ "${PV}" = "9999" ] && use doc && dodoc doc/manual/twmode/twmode.html
	elisp-install ${PN} twittering-mode.el *.elc || die
}
