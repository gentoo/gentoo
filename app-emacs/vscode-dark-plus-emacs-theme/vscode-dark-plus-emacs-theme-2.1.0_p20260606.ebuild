# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Accurate port of the default Visual Studio Code Dark+ theme for GNU Emacs"
HOMEPAGE="https://github.com/ianyepan/vscode-dark-plus-emacs-theme/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/ianyepan/${PN}"
else
	[[ "${PV}" == *20260606 ]] && COMMIT=c401b44809bfbf5928582efddc19ddda4f271ed4

	SRC_URI="https://github.com/ianyepan/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.snapshot.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_install() {
	elisp-make-autoload-file
	elisp_src_install
}
