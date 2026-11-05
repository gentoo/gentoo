# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="26.1"

inherit elisp

DESCRIPTION="Conveniently define themes for GNU Emacs"
HOMEPAGE="https://github.com/jasonm23/autothemer/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jasonm23/${PN}.git"
else
	SRC_URI="https://github.com/ocodo/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/dash-2.10.0
"
BDEPEND="
	${RDEPEND}
"

SITEFILE="50${PN}-gentoo.el"
DOCS=( {CONTRIBUTING,README,function-reference}.md )

elisp-enable-tests ert tests -l tests/${PN}-tests.el
