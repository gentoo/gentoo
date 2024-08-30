# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Gleam grammar for Tree-sitter"
HOMEPAGE="https://github.com/gleam-lang/tree-sitter-gleam"
SRC_URI="https://github.com/gleam-lang/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

# Highlight tests failing is a known issue.
# https://github.com/gleam-lang/tree-sitter-gleam/issues/83
RESTRICT="test"
