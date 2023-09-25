# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="X protocol Emacs Lisp Binding"
HOMEPAGE="https://github.com/ch11ng/xelb/"
SRC_URI="https://github.com/ch11ng/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-editors/emacs[gui]
	x11-apps/xauth
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
