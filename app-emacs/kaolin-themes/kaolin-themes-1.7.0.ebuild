# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Set of eye pleasing themes for GNU Emacs"
HOMEPAGE="https://github.com/ogdenwebb/emacs-kaolin-themes"

MY_PN="emacs-${PN}"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URL="https://github.com/ogdenwebb/${MY_PN}.git"
else
	SRC_URI="https://github.com/ogdenwebb/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

RDEPEND="app-emacs/autothemer"
BDEPEND="${RDEPEND}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile *.el themes/*.el
}

src_install() {
	elisp-install ${PN} *.el *.elc themes/*.el themes/*.elc
	elisp-make-site-file "${SITEFILE}"
}
