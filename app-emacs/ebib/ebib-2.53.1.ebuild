# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="BibTeX database manager for Emacs"
HOMEPAGE="https://joostkremers.github.io/ebib/
	https://github.com/joostkremers/ebib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/joostkremers/${PN}"
else
	SRC_URI="https://github.com/joostkremers/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-29.1
	>=app-emacs/parsebib-6.0
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
