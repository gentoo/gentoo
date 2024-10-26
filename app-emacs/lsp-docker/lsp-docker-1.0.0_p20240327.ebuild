# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs library to leverage lsp-mode in the Docker environment"
HOMEPAGE="https://github.com/emacs-lsp/lsp-docker/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-lsp/${PN}.git"
else
	COMMIT_SHA=bf99b65791ce8736b2756bf42cae67d7bc5294b7
	SRC_URI="https://github.com/emacs-lsp/${PN}/archive/${COMMIT_SHA}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_SHA}"

	KEYWORDS="amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/dash
	app-emacs/f
	app-emacs/ht
	app-emacs/lsp-mode
	app-emacs/s
	app-emacs/yaml
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
