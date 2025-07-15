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

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.1.0.0
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}"

src_install() {
	rm "./${PN}-test.el"* || die

	elisp_src_install
}
