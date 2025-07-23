# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

RUST_MIN_VER="1.82"
inherit cargo

MY_PN=tree-sitter
MY_P=${MY_PN}-${PV}

DESCRIPTION="Command-line tool for creating and testing tree-sitter grammars"
HOMEPAGE="https://github.com/tree-sitter/tree-sitter"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${MY_P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${MY_PN}/releases/download/v${PV}/${MY_P}-crates.tar.xz"
S="${WORKDIR}"/${MY_P}/cli

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD CC0-1.0 ISC LGPL-3+
	MIT MPL-2.0 Unicode-3.0 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

# Test seems to require files (grammar definitions) that we don't have.
RESTRICT="test"

BDEPEND="~dev-libs/tree-sitter-${PV}:="
RDEPEND="${BDEPEND}"

QA_FLAGS_IGNORED="usr/bin/${MY_PN}"
