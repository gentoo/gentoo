# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Additional and improved binding conditionals for GNU Emacs"
HOMEPAGE="https://github.com/tarsius/cond-let/
	https://github.com/tarsius/cond-let/wiki/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tarsius/${PN}"
else
	SRC_URI="https://github.com/tarsius/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert . -l "${PN}-tests.el"

src_install() {
	rm -f "${PN}-tests.el"*

	elisp_src_install
}
