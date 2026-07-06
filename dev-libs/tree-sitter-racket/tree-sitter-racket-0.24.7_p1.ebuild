# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Racket programming language grammar for Tree-sitter"
HOMEPAGE="https://github.com/6cdh/tree-sitter-racket/"
SRC_URI="https://github.com/6cdh/tree-sitter-racket/archive/v${PV/_p/-}.tar.gz
	-> ${P}.gh.tar.gz"
S="${WORKDIR}/${P/_p/-}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DOCS=( README.md )

src_install() {
	tree-sitter-grammar_src_install
	einstalldocs
}
