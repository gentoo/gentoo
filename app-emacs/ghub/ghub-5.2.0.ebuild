# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Minuscule client library for the Git forge APIs"
HOMEPAGE="https://magit.vc/manual/ghub/
	https://github.com/magit/ghub/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.1.0.1
	>=app-emacs/cond-let-1.0.0
	>=app-emacs/llama-1.0.4
	>=app-emacs/treepy-0.1.3
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( README.org )
ELISP_TEXINFO="docs/ghub.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	mv ./lisp/*.el . || die

	elisp_src_prepare
}
