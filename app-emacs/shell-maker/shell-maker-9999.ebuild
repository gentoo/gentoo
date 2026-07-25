# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="27.1"

inherit elisp

DESCRIPTION="Interaction mode for making comint shells for GNU Emacs"
HOMEPAGE="https://github.com/xenodium/shell-maker/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/xenodium/${PN}"
else
	SRC_URI="https://github.com/xenodium/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( CHANGELOG.md README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert ./tests/ \
	-l "${PN}-history-tests.el" -l markdown-overlays-images-tests.el

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
	elisp-make-site-file "${SITEFILE}"
}
