# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler32-1.2.0
	app_dirs-1.2.1
	autocfg-1.0.1
	bitflags-1.2.1
	byteorder-1.3.4
	cc-1.0.66
	cfg-if-1.0.0
	deflate-0.7.20
	fuchsia-cprng-0.1.1
	getopts-0.2.21
	glob-0.2.11
	ico-0.1.0
	inflate-0.3.4
	lazy_static-1.4.0
	libc-0.2.126
	num-integer-0.1.44
	num-iter-0.1.42
	num-traits-0.2.14
	ole32-sys-0.2.0
	png-0.11.0
	rand-0.4.6
	rand_core-0.3.1
	rand_core-0.4.2
	rdrand-0.4.0
	sdl2-0.35.2
	sdl2-sys-0.35.2
	serde-1.0.118
	shell32-sys-0.1.2
	toml-0.5.9
	unicode-width-0.1.8
	version-compare-0.1.0
	winapi-0.2.8
	winapi-0.3.9
	winapi-build-0.1.1
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	winres-0.1.12
	xdg-2.2.0"
inherit cargo desktop xdg

DESCRIPTION="Narrative meta-puzzle game"
HOMEPAGE="https://mdsteele.games/syzygy/"
SRC_URI="
	https://github.com/mdsteele/syzygy/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

LICENSE="BSD GPL-3+ ISC MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-libs/libsdl2[sound,video]"
DEPEND="${RDEPEND}"
BDEPEND=">=virtual/rust-1.60"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_configure() {
	local myfeatures=( embed_rsrc )

	cargo_src_configure
}

src_install() {
	cargo_src_install

	make_desktop_entry ${PN} "System Syzygy"
	local s
	for s in 32 128 512; do
		newicon -s ${s} data/icon/${s}x${s}.png ${PN}.png
	done
}
