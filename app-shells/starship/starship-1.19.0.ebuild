# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

inherit cargo

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://starship.rs/"
SRC_URI="
	https://github.com/starship/starship/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"
SRC_URI+="https://dev.gentoo.org/~arthurzam/distfiles/app-shells/${PN}/${P}-crates.tar.xz"

LICENSE="ISC"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD CC0-1.0 ISC MIT MPL-2.0 Unicode-DFS-2016 Unlicense
	WTFPL-2 ZLIB
"

SLOT="0"
KEYWORDS="amd64 arm64"

BDEPEND="
	dev-build/cmake
	>=virtual/rust-1.74.1
"

QA_FLAGS_IGNORED="usr/bin/starship"

src_prepare() {
	sed -e '/strip/s/true/false/' -i Cargo.toml || die # bug 866133
	default
}

src_configure() {
	export PKG_CONFIG_ALLOW_CROSS=1
	export OPENSSL_NO_VENDOR=true

	cargo_src_configure
}

src_install() {
	cargo_src_install
	dodoc README.md CHANGELOG.md
}

pkg_postinst() {
	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test "${v}" -lt "1.9.0"; then
			einfo "Note that vicmd_symbol config option was renamed to vimcmd_symbol in version 1.9"
		fi
	done
}
