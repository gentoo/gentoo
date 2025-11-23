# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Integration between lsp-mode and treemacs"
HOMEPAGE="https://github.com/emacs-lsp/lsp-treemacs/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-lsp/${PN}"
else
	SRC_URI="https://github.com/emacs-lsp/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/dash
	app-emacs/f
	app-emacs/ht
	app-emacs/lsp-mode
	app-emacs/treemacs
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-themes-icon-directory.patch"
)

DOCS=( README.org screenshots )
SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	elisp_src_prepare

	sed -e "s|@SITEETC@|${SITEETC}/${PN}|" -i "${PN}-themes.el" || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r icons
}
