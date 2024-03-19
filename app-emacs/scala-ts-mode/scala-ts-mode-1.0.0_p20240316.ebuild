# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

MY_COMMIT="11a01d726ac4fafb8a6688459ac79b41333bd6c8"
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
