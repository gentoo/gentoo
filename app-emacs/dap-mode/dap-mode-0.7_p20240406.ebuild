# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Debug Adapter Protocol mode"
HOMEPAGE="https://github.com/emacs-lsp/dap-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-lsp/${PN}"
else
	COMMIT_SHA=a414b18ea774ae75bdc7344af500b6f15849a65d
	SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${COMMIT_SHA}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_SHA}"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/bui
	app-emacs/dash
	app-emacs/f
	app-emacs/ht
	app-emacs/hydra
	app-emacs/lsp-docker
	app-emacs/lsp-mode
	app-emacs/lsp-treemacs
	app-emacs/posframe
	app-emacs/s
"
BDEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-dap-ui-images-root-dir.patch"
)

DOCS=( CHANGELOG.org README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test

src_prepare() {
	elisp_src_prepare

	sed "s|@SITEETC@|${SITEETC}/${PN}|" -i dap-ui.el || die
}

src_install() {
	elisp_src_install

	insinto "${SITEETC}/${PN}"
	doins -r icons
}
