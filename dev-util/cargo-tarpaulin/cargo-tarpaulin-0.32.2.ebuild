# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.76.0"

inherit cargo

DESCRIPTION="Cargo-Tarpaulin is a tool to determine code coverage achieved via tests"
HOMEPAGE="https://github.com/xd009642/tarpaulin"
SRC_URI="https://github.com/xd009642/tarpaulin/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/tarpaulin/releases/download/${PV}/${P#cargo-}-crates.tar.xz"
S="${WORKDIR}/${P#cargo-}"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="/usr/bin/cargo-tarpaulin"

PATCHES=(
	# integration tests require internet access
	"${FILESDIR}/cargo-tarpaulin-0.20.1-tests.patch"
	# test fails when not in a git repo
	"${FILESDIR}/cargo-tarpaulin-0.25.0-tests.patch"
)

DOCS=(
	CHANGELOG.md
	CONTRIBUTING.md
	README.md
)

src_install() {
	cargo_src_install

	dodoc "${DOCS[@]}"
}
