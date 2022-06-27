# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=45778f5731c97a21a83e3b965cbde42018709afd

inherit elisp

DESCRIPTION="Completion back-ends for for math unicode symbols and latex tags"
HOMEPAGE="https://github.com/vspinu/company-math/"
SRC_URI="https://github.com/vspinu/${PN}/archive/${H}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-emacs/company-mode
	app-emacs/math-symbol-lists
"
BDEPEND="${RDEPEND}"

DOCS=( readme.md )
SITEFILE="50${PN}-gentoo.el"
