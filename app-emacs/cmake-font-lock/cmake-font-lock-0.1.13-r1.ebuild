# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=26

inherit elisp

DESCRIPTION="Advanced, type aware, highlight support for CMake"
HOMEPAGE="https://github.com/Lindydancer/cmake-font-lock"
SRC_URI="https://github.com/Lindydancer/${PN}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	|| (
		app-emacs/cmake-mode
		dev-util/cmake[emacs(-)]
	)
"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
