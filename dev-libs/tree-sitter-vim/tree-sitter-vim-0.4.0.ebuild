# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TS_BINDINGS=( python )

inherit tree-sitter-grammar

DESCRIPTION="Vimscript grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter-grammars/tree-sitter-vim"
SRC_URI="https://github.com/tree-sitter-grammars/tree-sitter-vim/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86"
