# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Emacs Java IDE using Eclipse JDT Language Server"
HOMEPAGE="https://emacs-lsp.github.io/lsp-java/
	https://github.com/emacs-lsp/lsp-java/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-lsp/${PN}"
else
	SRC_URI="https://github.com/emacs-lsp/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-editors/emacs-${NEED_EMACS}:*[gif]
	>=app-emacs/dap-mode-0.5
	>=app-emacs/dash-2.18.0
	>=app-emacs/f-0.20.0
	>=app-emacs/ht-2.0
	>=app-emacs/lsp-mode-10.0.0
	>=app-emacs/markdown-mode-2.3
	>=app-emacs/request-0.3.0
	>=app-emacs/treemacs-2.5
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
	doins -r ./icons/
}
