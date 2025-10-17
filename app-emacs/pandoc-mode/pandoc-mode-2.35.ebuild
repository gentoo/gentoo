# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs minor mode for interacting with Pandoc"
HOMEPAGE="https://joostkremers.github.io/pandoc-mode/
	https://github.com/joostkremers/pandoc-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joostkremers/${PN}.git"
else
	SRC_URI="https://github.com/joostkremers/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"

BDEPEND="
	app-emacs/dash
	app-emacs/hydra
"
RDEPEND="
	${BDEPEND}
	virtual/pandoc
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp_src_install

	doinfo "${PN}.info"
}
