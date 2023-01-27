# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Display all-the-icons icons for all buffers in Emacs' ibuffer"
HOMEPAGE="https://github.com/seagle0128/all-the-icons-ibuffer/"
SRC_URI="https://github.com/seagle0128/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="app-emacs/all-the-icons"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
