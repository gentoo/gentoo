# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=29

inherit elisp

DESCRIPTION="Automatic installation, usage, fallback for tree-sitter modes in Emacs 29"
HOMEPAGE="https://github.com/renzmann/treesit-auto/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/renzmann/${PN}.git"
else
	SRC_URI="https://github.com/renzmann/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
