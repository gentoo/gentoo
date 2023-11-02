# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=29

inherit elisp

DESCRIPTION="Automatic installation, usage, fallback for tree-sitter modes in Emacs 29"
HOMEPAGE="https://github.com/renzmann/treesit-auto"

if [[ ${PV} == *_p* ]] ; then
	MY_COMMIT=""
	SRC_URI="https://github.com/renzmann/treesit-auto/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_COMMIT}
else
	SRC_URI="https://github.com/renzmann/treesit-auto/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
