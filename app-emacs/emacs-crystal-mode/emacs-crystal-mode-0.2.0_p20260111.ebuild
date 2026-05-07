# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

[[ ${PV} == *p20260111 ]] && COMMIT=559e1d8ff9bb87a4e937978001386bfb58b113a0

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing Crystal programming language files"
HOMEPAGE="https://github.com/crystal-lang-tools/emacs-crystal-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/crystal-lang-tools/${PN}"
else
	SRC_URI="https://github.com/crystal-lang-tools/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/flycheck-30
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert tests -l tests/crystal-mode-tests.el

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
