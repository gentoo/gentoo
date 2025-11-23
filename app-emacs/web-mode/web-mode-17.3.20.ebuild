# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo elisp

DESCRIPTION="Web template editing mode for Emacs"
HOMEPAGE="https://web-mode.org/
	https://github.com/fxbois/web-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/fxbois/${PN}.git"
else
	SRC_URI="https://github.com/fxbois/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	edo bash ./run.sh
}
