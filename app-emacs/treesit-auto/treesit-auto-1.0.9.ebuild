# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="29"
inherit elisp

DESCRIPTION="Automatic installation, usage, fallback for tree-sitter modes in Emacs 29"
HOMEPAGE="https://github.com/renzmann/treesit-auto/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/renzmann/${PN}.git"
else
	SRC_URI="https://github.com/renzmann/treesit-auto/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-editors/emacs[tree-sitter(+)]
"
BDEPEND="
	${RDEPEND}
"

DOCS=( CONTRIBUTING.org README.org )
SITEFILE="50${PN}-gentoo.el"
