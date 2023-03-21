# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26.3

inherit elisp

DESCRIPTION="A minimal Emacs LSP client"
HOMEPAGE="https://github.com/joaotavora/eglot/
	https://elpa.gnu.org/packages/eglot.html"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/joaotavora/${PN}.git"
else
	if [[ ${PV} == 1.13 ]] ; then
		COMMIT=563d01ab6d4a2f92f38bf92e9702014191031343
		SRC_URI="https://github.com/joaotavora/${PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}-${COMMIT}
	else
		SRC_URI="https://github.com/joaotavora/${PV}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
	fi
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
RESTRICT="test"

RDEPEND="app-emacs/external-completion"
BDEPEND="${RDEPEND}"

SITEFILE="50${PN}-gentoo.el"

src_install() {
	rm eglot-tests.el* || die

	elisp-make-autoload-file "${S}"/${PN}-autoload.el "${S}"/
	elisp_src_install
}
