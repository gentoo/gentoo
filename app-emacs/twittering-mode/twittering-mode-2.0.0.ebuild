# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit elisp eutils

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/hayamiz/twittering-mode.git"
	inherit git-r3
	IUSE="doc"
else
	SRC_URI="mirror://sourceforge/twmode/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	RESTRICT="test"
	IUSE=""
fi

DESCRIPTION="Emacs major mode for Twitter"
HOMEPAGE="http://twmode.sourceforge.net/"

LICENSE="GPL-2+"
SLOT="0"

DEPEND=""
RDEPEND="app-crypt/gnupg"

src_compile() {
	elisp-compile twittering-mode.el
	[[ ${PV} == *9999 ]] && use doc && emake -C doc/manual
}

src_test() {
	emake check
}

src_install() {
	[[ ${PV} == *9999 ]] && use doc && dodoc doc/manual/twmode/twmode.html
	elisp-install ${PN} twittering-mode.el *.elc
}
