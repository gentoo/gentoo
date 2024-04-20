# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Alternative M-x interface for GNU Emacs"
HOMEPAGE="https://github.com/DarwinAwardWinner/amx/"
SRC_URI="https://github.com/DarwinAwardWinner/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

# TODO: When ido is packaged: || ( app-emacs/ido app-emacs/ivy )
RDEPEND="
	app-emacs/s
	app-emacs/ivy
"
BDEPEND="${RDEPEND}"

DOCS=( README.mkdn )
SITEFILE="50${PN}-gentoo.el"
