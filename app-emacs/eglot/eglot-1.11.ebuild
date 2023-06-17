# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.3

inherit elisp

DESCRIPTION="A minimal Emacs LSP client"
HOMEPAGE="https://github.com/joaotavora/eglot/
	https://elpa.gnu.org/packages/eglot.html"
SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-emacs/external-completion"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-make-autoload-file "${S}"/${PN}-autoload.el "${S}"/
	elisp_src_install
}
