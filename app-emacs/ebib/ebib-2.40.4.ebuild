# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="BibTeX database manager for Emacs"
HOMEPAGE="https://joostkremers.github.io/ebib/
	https://github.com/joostkremers/ebib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joostkremers/${PN}.git"
else
	SRC_URI="https://github.com/joostkremers/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-29.1.4.4
	app-emacs/parsebib
"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/with-simulated-input
	)
"

DOCS=( README.md docs )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test

src_install() {
	elisp_src_install

	doinfo "${PN}.info"
}
