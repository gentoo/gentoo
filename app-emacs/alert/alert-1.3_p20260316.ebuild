# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Growl-style notification system for Emacs"
HOMEPAGE="https://github.com/jwiegley/alert/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jwiegley/${PN}"
else
	[[ "${PV}" == *p20260316 ]] && COMMIT=fb8f1fc7f769d7b3ed93b47bd8252f2947c96d9c
	SRC_URI="https://github.com/jwiegley/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.snapshot.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	>=app-emacs/gntp-0.1
	>=app-emacs/log4e-0.3.0
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert .

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
	elisp-make-site-file "${SITEFILE}"
}
