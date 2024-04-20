# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tree-sitter-grammar

DESCRIPTION="Bash grammar for Tree-sitter"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter-bash"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

# Override eclass SRC_URI as 0.20.4 was bumped incorrectly.
SRC_URI="https://github.com/tree-sitter/${PN}/archive/v${PV}.tar.gz
	-> ${P}-2.tar.gz"
