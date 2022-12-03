# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="TypeScript grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-typescript"
S="${WORKDIR}"/${PN}-${PV}/typescript/src

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
