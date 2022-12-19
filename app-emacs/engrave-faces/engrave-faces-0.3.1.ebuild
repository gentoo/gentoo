# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Convert font-lock faces to other formats"
HOMEPAGE="https://github.com/tecosaur/engrave-faces/"
SRC_URI="https://github.com/tecosaur/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
