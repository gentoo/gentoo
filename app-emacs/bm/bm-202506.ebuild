# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Visible bookmarks in buffer"
HOMEPAGE="https://joodland.github.io/bm/
	https://www.emacswiki.org/emacs/VisibleBookmarks"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joodland/bm"
else
	SRC_URI="https://github.com/joodland/bm/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~sparc ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l bm-tests.el

src_install() {
	rm bm-tests.el* || die

	elisp_src_install
}
