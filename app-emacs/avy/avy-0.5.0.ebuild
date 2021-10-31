# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="24.1"

inherit elisp

DESCRIPTION="A GNU Emacs package for jumping to visible text using a char-based decision tree"
HOMEPAGE="https://github.com/abo-abo/avy"
SRC_URI="https://github.com/abo-abo/avy/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64"

SITEFILE="50${PN}-gentoo.el"
DOCS=( README.md  doc/Changelog.org )
ELISP_REMOVE=".dir-locals.el"

src_compile() {
	elisp-make-autoload-file "${S}/${PN}-autoload.el" "${S}/"
	elisp_src_compile
}
