# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Scala grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-scala"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_prepare() {
	default

	# Fix incorrect paths
	sed -i -e 's:queries/scala:queries/:' package.json || die
}
