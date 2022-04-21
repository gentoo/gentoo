# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=6b7e837b0cf0129e9d7d6abae48093cf599bb9e8
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Hiding or abbreviation of the mode line displays (lighters)"
HOMEPAGE="https://github.com/myrjola/diminish.el/"
SRC_URI="https://github.com/myrjola/${PN}.el/archive/${H}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}.el-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
