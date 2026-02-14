# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Transient commands abstraction for GNU Emacs"
HOMEPAGE="https://magit.vc/manual/transient/
	https://github.com/magit/transient/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magit/${PN}"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
	app-emacs/cond-let
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( CHANGELOG README.org "docs/${PN}.org" )
ELISP_TEXINFO="docs/${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert test -l "${PN}-tests"

src_prepare() {
	mv ./lisp/*.el . || die

	elisp_src_prepare
}
