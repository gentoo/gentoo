# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="29.2"

inherit elisp

DESCRIPTION="A Git porcelain inside Emacs"
HOMEPAGE="https://magit.vc/
	https://github.com/magit/magit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
fi

S="${WORKDIR}/${P}/lisp"

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
	app-emacs/cond-let
	app-emacs/dash
	app-emacs/llama
	app-emacs/transient
	app-emacs/with-editor
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
"
RDEPEND+="
	>=dev-vcs/git-2.44.2
"

DOCS=( ../README.md ../docs/AUTHORS.md ../docs/RelNotes )
ELISP_TEXINFO="../docs/*.texi"
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	echo "(setq ${PN}-version \"${PV}\")" > "./${PN}-version.el" || die
}
