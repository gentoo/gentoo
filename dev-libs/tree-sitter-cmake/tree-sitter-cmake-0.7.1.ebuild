# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

TS_BINDINGS=( python )

inherit tree-sitter-grammar

DESCRIPTION="CMake grammar for tree-sitter"
HOMEPAGE="https://github.com/uyha/tree-sitter-cmake"
SRC_URI="https://github.com/uyha/tree-sitter-cmake/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
