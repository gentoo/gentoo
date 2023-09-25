# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.3

inherit elisp

DESCRIPTION="A minimal Emacs LSP client for GNU Emacs"
HOMEPAGE="https://github.com/joaotavora/eglot/
	https://elpa.gnu.org/packages/eglot.html"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/joaotavora/${PN}.git"
elif [[ ${PV} == 1.15 ]] ; then
	COMMIT=8b5532dd32b25276c1857508030b207f765ef9b6
	SRC_URI="https://github.com/joaotavora/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"  # Requires the newest "project" package.

RDEPEND="app-emacs/external-completion"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo-r1.el"

src_install() {
	elisp-make-autoload-file
	elisp_src_install
}
