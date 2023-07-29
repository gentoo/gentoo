# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="GNU Emacs major mode for editing PHP code"
HOMEPAGE="https://github.com/emacs-php/php-mode/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emacs-php/${PN}.git"
else
	SRC_URI="https://github.com/emacs-php/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

S="${WORKDIR}"/${P}/lisp

LICENSE="GPL-3+"
SLOT="0"

DOCS=( ../AUTHORS.md ../CHANGELOG.md ../CONTRIBUTING.md ../README{,.ja}.md ../docs )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -L ../tests -l ../tests/php-mode-test.el

src_test() {
	touch ../tests/project/1/.git || die

	elisp_src_test
}
