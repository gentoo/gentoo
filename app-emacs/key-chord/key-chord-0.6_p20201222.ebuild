# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=7f7fd7c5bd2b996fa054779357e1566f7989e07d
NEED_EMACS=24

inherit elisp

DESCRIPTION="Map pairs of simultaneously pressed keys to commands"
HOMEPAGE="https://github.com/emacsorphanage/key-chord/"
SRC_URI="https://github.com/emacsorphanage/${PN}/archive/${H}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
