# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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

	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"

DOCS=( CHANGELOG README.org "docs/${PN}.org" )
ELISP_TEXINFO="docs/${PN}.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	mv ./lisp/*.el . || die

	elisp_src_prepare
}
