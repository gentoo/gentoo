# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=04dbcddeba1da1f39e885bc0d36240ff37d829e9  # ctable.el == 0.1.3 without tag
NEED_EMACS=24.3

inherit elisp

DESCRIPTION="Table Component for Emacs Lisp"
HOMEPAGE="https://github.com/kiwanami/emacs-ctable/"
SRC_URI="https://github.com/kiwanami/emacs-${PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/emacs-${PN}-${COMMIT}

LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DOCS=( readme.md img samples )
ELISP_REMOVE="test-${PN}.el"  # tests are interactive and hang up?
SITEFILE="50${PN}-gentoo.el"
