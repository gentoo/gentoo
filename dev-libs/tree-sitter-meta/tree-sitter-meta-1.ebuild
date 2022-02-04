# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Metapackage for Tree Sitter packages"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/tree-sitter
	dev-libs/tree-sitter-bash
	dev-libs/tree-sitter-c
	dev-libs/tree-sitter-cpp
	dev-libs/tree-sitter-css
	dev-libs/tree-sitter-go
	dev-libs/tree-sitter-html
	dev-libs/tree-sitter-javascript
	dev-libs/tree-sitter-json
	dev-libs/tree-sitter-meta
	dev-libs/tree-sitter-php
	dev-libs/tree-sitter-scala
	dev-libs/tree-sitter-typescript"
