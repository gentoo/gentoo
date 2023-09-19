# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26

inherit elisp

DESCRIPTION="GNU Emacs implementation of miniKanren, logic programming language"
HOMEPAGE="https://github.com/nickdrozd/reazon/"
SRC_URI="https://github.com/nickdrozd/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGELOG.org README.org )
SITEFILE="50${PN}-gentoo.el"
