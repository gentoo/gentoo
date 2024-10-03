# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="26.3"

inherit elisp

DESCRIPTION="A minimal Emacs LSP client for GNU Emacs"
HOMEPAGE="https://github.com/joaotavora/eglot/
	https://elpa.gnu.org/packages/eglot.html"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joaotavora/${PN}.git"
else
	SRC_URI="https://dev.gentoo.org/~xgqt/distfiles/repackaged/${P}.tar.xz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/external-completion
"
BDEPEND="
	${RDEPEND}
"

ELISP_REMOVE="${PN}-pkg.el"

DOCS=( EGLOT-NEWS )
SITEFILE="50${PN}-gentoo-r1.el"

src_install() {
	elisp-make-autoload-file
	elisp_src_install
}
