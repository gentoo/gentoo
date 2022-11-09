# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=dc9a5de1cb3ee05db5794d824610959a1f603bc9
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Emacs Flycheck backend for Nim language using nimsuggest"
HOMEPAGE="https://github.com/yuutayamada/flycheck-nimsuggest/"
SRC_URI="https://github.com/yuutayamada/${PN}/archive/${H}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0"

BDEPEND="app-emacs/flycheck"
RDEPEND="
	${BDEPEND}
	dev-lang/nim
"
PDEPEND="app-emacs/nim-mode"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
