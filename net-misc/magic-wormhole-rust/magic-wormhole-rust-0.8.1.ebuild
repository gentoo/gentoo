# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"
RUST_MIN_VER="1.92"
inherit cargo

MY_PN=magic-wormhole.rs
MY_P=${MY_PN}-${PV}

DESCRIPTION="Rust implementation of Magic Wormhole, with new features and enhancements"
HOMEPAGE="http://magic-wormhole.io/ https://github.com/magic-wormhole/magic-wormhole.rs"
SRC_URI="
	https://github.com/magic-wormhole/magic-wormhole.rs/archive/refs/tags/${PV}.tar.gz -> ${MY_P}.tar.gz
	https://github.com/gentoo-crate-dist/magic-wormhole.rs/releases/download/${PV}/${MY_P}-crates.tar.xz
"
S="${WORKDIR}"/${MY_P}

LICENSE="EUPL-1.2"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 ISC MIT MPL-2.0 Unicode-3.0 Unlicense ZLIB
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/wormhole-rs"

src_test() {
	local -x CLICOLOR_FORCE=
	cargo_src_test
}

src_install() {
	cargo_src_install --path cli
}
