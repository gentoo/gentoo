# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=25.1

inherit elisp

DESCRIPTION="Flycheck checker for the GNU Guile Scheme implementation"
HOMEPAGE="https://github.com/flatwhatson/flycheck-guile/"
SRC_URI="https://github.com/flatwhatson/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-emacs/flycheck
	app-emacs/geiser-guile
"
RDEPEND="
	${BDEPEND}
	>=dev-scheme/guile-2.0.0
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
