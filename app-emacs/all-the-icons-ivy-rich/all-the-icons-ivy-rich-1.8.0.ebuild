# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Display icons for ivy buffers in Emacs"
HOMEPAGE="https://github.com/seagle0128/all-the-icons-ivy-rich/"
SRC_URI="https://github.com/seagle0128/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-emacs/all-the-icons
	app-emacs/ivy-rich
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
