# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=24.1

inherit elisp

DESCRIPTION="Ensure environment variables inside Emacs are the same as in shell"
HOMEPAGE="https://github.com/purcell/exec-path-from-shell/"
SRC_URI="https://github.com/purcell/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
