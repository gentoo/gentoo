# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=tree-sitter
MY_P=${MY_PN}-${PV}

CRATES=""
inherit cargo

DESCRIPTION="Command-line tool for creating and testing tree-sitter grammars"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz
	${CARGO_CRATE_URIS}
	https://dev.gentoo.org/~arthurzam/distfiles/dev-util/${PN}/${P}-crates.tar.xz"
S="${WORKDIR}"/${MY_P}/cli

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD ISC MIT MPL-2.0
	Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# Test seems to require files (grammar definitions) that we don't have.
RESTRICT="test"

BDEPEND="~dev-libs/tree-sitter-${PV}"
RDEPEND="${BDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${MY_PN}"
