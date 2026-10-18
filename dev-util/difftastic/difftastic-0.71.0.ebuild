# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.85.0"

inherit cargo

DESCRIPTION="A structural diff that understands syntax"
HOMEPAGE="http://difftastic.wilfred.me.uk/"
SRC_URI="
	https://github.com/Wilfred/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-crate-dist/${PN}/releases/download/${PV}/${P}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD MIT Unicode-DFS-2016"
# tree-sitter-newick
LICENSE+=" CeCILL-C"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="dev-libs/jemalloc"
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/difft"

DOCS=( CHANGELOG.md README.md manual/ )

pkg_setup() {
	rust_pkg_setup

	export JEMALLOC_OVERRIDE="${EPREFIX}/usr/$(get_libdir)/libjemalloc.so"
}

src_prepare() {
	rm manual/.gitignore || die

	sed -e '/^lto = /d' -i Cargo.toml || die

	# Enable feature required to use system jemalloc.
	sed \
		-e 's/^tikv-jemallocator = "\(.*\)"/tikv-jemallocator = { version = "\1", features = ["unprefixed_malloc_on_supported_platforms"] }/' \
		-i Cargo.toml || die

	default
}

src_install() {
	cargo_src_install
	einstalldocs
}
