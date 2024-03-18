# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="OCaml grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-ocaml"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

S="${WORKDIR}/${P}/ocaml"
