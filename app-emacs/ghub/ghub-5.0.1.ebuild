# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
		-> ${P}.tar.gz"

	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
	app-emacs/llama
	app-emacs/treepy
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
