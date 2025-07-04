# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
inherit cargo flag-o-matic

DESCRIPTION="A structural diff that understands syntax."
HOMEPAGE="http://difftastic.wilfred.me.uk/"
SRC_URI="
	https://github.com/Wilfred/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/gentoo-crate-dist/${PN}/releases/download/${PV}/${P}-crates.tar.xz
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0 BSD MIT Unicode-DFS-2016"
# owo-colors
LICENSE+=" MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

QA_FLAGS_IGNORED="usr/bin/difft"

DOCS=( CHANGELOG.md README.md manual/ )

src_prepare() {
	rm manual/.gitignore || die

	default
}

src_configure() {
	# Workaround for old bundled mimalloc in mimalloc crate, see
	# bug #944110, but updating it should be done with caution, see
	# https://github.com/purpleprotocol/mimalloc_rust/issues/109.
	append-cflags -std=gnu17
	cargo_src_configure
}

src_install() {
	cargo_src_install
	einstalldocs
}
