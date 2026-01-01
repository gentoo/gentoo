# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.86"
CRATES=""
inherit cargo

DESCRIPTION="Implementation of Tor in Rust"
HOMEPAGE="https://tpo.pages.torproject.net/core/arti/ https://gitlab.torproject.org/tpo/core/arti/"

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.torproject.org/tpo/core/arti"
else
	SRC_URI="https://gitlab.torproject.org/tpo/core/${PN}/-/archive/${PN}-v${PV}/${PN}-${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"
	SRC_URI+=" https://github.com/gentoo-crate-dist/arti/releases/download/${PN}-v${PV}/${P}-crates.tar.xz"
	S="${WORKDIR}/${PN}-${PN}-v${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD Boost-1.0 CC0-1.0 ISC MIT MPL-2.0 openssl Unicode-3.0
	Unlicense ZLIB
"
SLOT="0"

DEPEND="app-arch/xz-utils
	app-arch/zstd:=
	dev-db/sqlite:3
	dev-libs/openssl:="
RDEPEND="${DEPEND}"

QA_FLAGS_IGNORED="usr/bin/arti"

src_unpack() {
	if [[ "${PV}" == *9999 ]]; then
		git-r3_src_unpack
		cargo_live_src_unpack
	else
		cargo_src_unpack
	fi
}

src_compile() {
	export ZSTD_SYS_USE_PKG_CONFIG=1
	for crate in crates/*; do
		pushd "${crate}" || die
		cargo_src_compile
		popd >/dev/null || die
	done
}

src_install() {
	pushd crates/arti >/dev/null || die

	cargo_src_install
	newdoc src/arti-example-config.toml arti.toml

	popd >/dev/null || die

	dodoc -r doc/*
}
