# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo

DESCRIPTION="A tool for generating C bindings to Rust code"
HOMEPAGE="https://github.com/mozilla/cbindgen/"
SRC_URI="https://github.com/mozilla/cbindgen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/cbindgen/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+="
	MIT Unicode-3.0
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
IUSE="test"

# Needs debugging enabled and lots of other problems.
# https://github.com/mozilla/cbindgen/issues?q=is%3Aissue+is%3Aopen+test
RESTRICT="test"

BDEPEND="test? ( dev-build/cmake )"

QA_FLAGS_IGNORED="usr/bin/cbindgen"
