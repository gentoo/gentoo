# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
RUST_MIN_VER="1.89.0"
inherit cargo optfeature shell-completion

DESCRIPTION="The minimal, blazing-fast, and infinitely customizable prompt for any shell"
HOMEPAGE="https://starship.rs/"
SRC_URI="https://github.com/starship/starship/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="ISC"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD CC0-1.0 ISC MIT MPL-2.0 Unicode-3.0 Unlicense WTFPL-2
	ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	dev-build/cmake
"

QA_FLAGS_IGNORED="usr/bin/starship"

src_prepare() {
	sed -e '/^strip/s/true/false/' -i Cargo.toml || die # bug 866133
	default
}

src_configure() {
	export PKG_CONFIG_ALLOW_CROSS=1
	export OPENSSL_NO_VENDOR=true

	cargo_src_configure
}

src_compile() {
	cargo_src_compile

	local STARSHIP_BIN="$(cargo_target_dir)/${PN}"

	# Prepare shell completion generation
	mkdir "${T}/completions" || die
	local shell
	for shell in bash fish zsh; do
		"${STARSHIP_BIN}" completions ${shell} > "${T}/completions/${shell}" || die
	done
}

src_install() {
	dobin "$(cargo_target_dir)/${PN}"
	dodoc README.md

	newbashcomp "${T}/completions/bash" "${PN}"
	newzshcomp "${T}/completions/zsh" "${PN}"
	newfishcomp "${T}/completions/fish" "${PN}.fish"
}

pkg_postinst() {
	optfeature "font support" media-fonts/iosevka media-fonts/noto-emoji
}
