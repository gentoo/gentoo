# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Improved JavaScript editing mode for GNU Emacs"
HOMEPAGE="https://github.com/mooz/js2-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/mooz/${PN}.git"
else
	SRC_URI="https://github.com/mooz/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( NEWS.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake test
}
