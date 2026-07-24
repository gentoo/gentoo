# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

MY_COMMIT="c7671e10419261ef70b1820d3b970ad39f6fcfe2"
DESCRIPTION="Emacs Scala Mode via Tree-Sitter"
HOMEPAGE="https://github.com/KaranAhlawat/scala-ts-mode"
SRC_URI="
	https://codeload.github.com/KaranAhlawat/scala-ts-mode/tar.gz/${MY_COMMIT}
		-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=app-editors/emacs-29[tree-sitter]
	dev-libs/tree-sitter-scala
"

DOCS="README.org"

SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}
