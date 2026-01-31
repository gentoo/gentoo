# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Prettify headings and plain lists in Org mode (use UTF8 bullets)"
HOMEPAGE="https://github.com/integral-dw/org-superstar-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/integral-dw/${PN}"
else
	SRC_URI="https://github.com/integral-dw/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( DEMO.org README.org demos )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake EMACS="${EMACS}" EFLAGS="${EMACSFLAGS}" -C tests
}
