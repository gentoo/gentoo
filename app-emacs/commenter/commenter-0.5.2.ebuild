# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.4

inherit elisp

DESCRIPTION="Set both single and multi line comment variables in Emacs Lisp"
HOMEPAGE="https://github.com/yuutayamada/commenter/"
SRC_URI="https://github.com/yuutayamada/${PN}/archive/v${PV}.tar.gz
			-> ${P}.tar.gz"

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
