# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.1

inherit elisp

DESCRIPTION="BibTeX database manager for Emacs"
HOMEPAGE="https://joostkremers.github.io/ebib/
	https://github.com/joostkremers/ebib/"
SRC_URI="https://github.com/joostkremers/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="app-emacs/parsebib"
BDEPEND="
	${RDEPEND}
	test? (
		app-emacs/ert-runner
		app-emacs/with-simulated-input
	)
"

DOCS=( README.md docs )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ert-runner -L . -L test --reporter ert+duration --script test || die
}

src_install() {
	elisp_src_install
	doinfo ${PN}.info
}
