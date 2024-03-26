# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Go grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-go"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

# Override eclass SRC_URI as 0.20.0 was bumped incorrectly.
SRC_URI="https://github.com/tree-sitter/${PN}/archive/v${PV}.tar.gz
	-> ${P}-2.tar.gz"
