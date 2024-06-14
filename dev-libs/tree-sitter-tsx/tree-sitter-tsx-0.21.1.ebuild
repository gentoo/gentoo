# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

MY_P=${P/tsx/typescript}
MY_PN=${PN/tsx/typescript}

DESCRIPTION="TSX grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-typescript"
SRC_URI="https://github.com/tree-sitter/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${MY_P}/tsx

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	# fix test corpus path
	ln -s ../common test || die

	tree-sitter-grammar_src_prepare
}
