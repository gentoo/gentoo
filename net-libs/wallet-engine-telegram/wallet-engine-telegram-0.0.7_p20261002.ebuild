# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.96.1"
inherit cargo flag-o-matic edo

DESCRIPTION="Cross-platform wallet engine for TON written in Rust (Telegram patchset)"
HOMEPAGE="https://github.com/i582/wallet-engine"

# Checking for updates:
# https://github.com/telegramdesktop/tdesktop/blob/dev/Telegram/build/docker/centos_env/Dockerfile
# 	(look for the git fetch line for wallet-engine)
# https://github.com/desktop-app/patches/blob/master/wallet-engine.patch
# 	(look at the most recent commit for this file)

# The PV of this package is the wallet-engine version followed by "_p" and the
# date of either the wallet-engine commit or the patch, whichever is most
# recent.

# Packing crates:
# pycargoebuild -c -d "$PWD/distfiles" . bindgen/cpp/bindgen

MY_PN="wallet-engine"
MY_PV="e59e0d89d7ee90c388bf36e3334c5b276f396697"
PATCHES_PV="82ed0c85bc1a1399a66b75ca7a978799c507e2ba"
SRC_URI="https://github.com/i582/wallet-engine/archive/${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV:0:7}.tar.gz
	https://archive.org/download/wallet-engine-e59e0d8-crates/wallet-engine-${MY_PV:0:7}-crates.tar.xz
	https://raw.githubusercontent.com/desktop-app/patches/${PATCHES_PV}/wallet-engine.patch
		-> wallet-engine-telegram-${PATCHES_PV:0:7}.patch"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

# Make sure this number changes when any function signature changes
SV="${PV//_p/.}"

LICENSE="|| ( Apache-2.0 MIT )"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0
	Unicode-3.0
"
# Dependent crate licenses (uniffi-bindgen-cpp)
LICENSE+=" Apache-2.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0/${SV}"
KEYWORDS="~amd64"

if [ ${PV} = 0.0.7_p20261002 ]; then
	# Failing tests
	RESTRICT+=" test"
fi

PATCHES=(
	"${DISTDIR}/wallet-engine-telegram-82ed0c8.patch"
)

src_compile() {
	local -Ix LDFLAGS
	append-ldflags -Wl,-soname,libwallet_engine-telegram.so.${SV}
	cargo_src_compile

	mkdir -p bindings/cpp || die
	cargo_env edo "${CARGO}" run \
		--manifest-path bindgen/cpp/bindgen/Cargo.toml --locked -- \
		--library --out-dir bindings/cpp \
		"$(cargo_target_dir)/libwallet_engine.so" || die
}

src_install() {
	einstalldocs
	newlib.so "$(cargo_target_dir)/libwallet_engine.so" libwallet_engine-telegram.so.${SV}
	dosym libwallet_engine-telegram.so.${SV} /usr/$(get_libdir)/libwallet_engine-telegram.so

	insinto /usr/include/wallet_engine-telegram
	doins bindings/cpp/*.hpp
	# The specific generated bindings must be compiled into the target project
	doins bindings/cpp/*.cpp
}
