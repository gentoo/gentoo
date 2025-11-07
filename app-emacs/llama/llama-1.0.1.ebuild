# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Compact syntax for short lambda"
HOMEPAGE="https://github.com/tarsius/llama/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tarsius/${PN}"
else
	SRC_URI="https://github.com/tarsius/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l "./${PN}-tests.el"

src_install() {
	rm "./${PN}-tests.el"* || die

	elisp_src_install
}
