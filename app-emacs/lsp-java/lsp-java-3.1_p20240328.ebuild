# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs Java IDE using Eclipse JDT Language Server"
HOMEPAGE="https://emacs-lsp.github.io/lsp-java/
	https://github.com/emacs-lsp/lsp-java/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-lsp/${PN}"
else
	COMMIT_SHA=9296ecd97310458d39338566c3491a27d90f5577
	SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${COMMIT_SHA}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_SHA}"

	KEYWORDS="amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/dap-mode
	app-emacs/dash
	app-emacs/f
	app-emacs/ht
	app-emacs/lsp-mode
	app-emacs/markdown-mode
	app-emacs/request
	app-emacs/treemacs
"
BDEPEND="
	${RDEPEND}
"

ELISP_REMOVE="
	Makefile
"
PATCHES=(
	"${FILESDIR}/${PN}-icons-3.1_p20240328.patch"
)

DOCS=( README.md images )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed -e "s|@SITEETC@|${SITEETC}/${PN}|" -i "${PN}.el" -i lsp-jt.el || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r icons
}
