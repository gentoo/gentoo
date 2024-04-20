# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_COMMIT="bf7efbbbfeb4540822c5deca3be5d71c4232f62f"
DESCRIPTION="Emacs client for ccls, a C/C++ language server"
HOMEPAGE="https://github.com/emacs-lsp/emacs-ccls"
SRC_URI="https://github.com/emacs-lsp/emacs-ccls/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${MY_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	app-emacs/dash
	app-emacs/lsp-mode
"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"
