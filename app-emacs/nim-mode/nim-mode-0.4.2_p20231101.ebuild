# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == *20231101 ]] && COMMIT=1338e5b0d5e111ad932efb77d3cad680cc3b86c9

inherit elisp

DESCRIPTION="Emacs major mode for the Nim programming language support"
HOMEPAGE="https://github.com/nim-lang/nim-mode/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/nim-lang/${PN}.git"
else
	SRC_URI="https://github.com/nim-lang/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
RESTRICT="test"  # Some test are broken.

RDEPEND="
	app-emacs/commenter
	app-emacs/epc
"
BDEPEND="
	${RDEPEND}
"
PDEPEND="
	app-emacs/flycheck-nimsuggest
"

DOCS=( README.md starterKit.nims )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests buttercup tests
