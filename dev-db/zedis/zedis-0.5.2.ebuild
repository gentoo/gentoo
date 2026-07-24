# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.95.0"
CRATES=""
COMMIT=9ec9ac63c4a81c0668534c6f28d3b04079ffe8e6

declare -A GIT_CRATES=(
	[collections]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/collections'
	[derive_refineable]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/refineable/derive_refineable'
	[gpui-component-assets]='https://github.com/longbridge/gpui-component;a9a7341c35b62f27ff512371c62419342264710c;gpui-component-%commit%/crates/assets'
	[gpui-component-macros]='https://github.com/longbridge/gpui-component;a9a7341c35b62f27ff512371c62419342264710c;gpui-component-%commit%/crates/macros'
	[gpui-component]='https://github.com/longbridge/gpui-component;a9a7341c35b62f27ff512371c62419342264710c;gpui-component-%commit%/crates/ui'
	[gpui]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui'
	[gpui_linux]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_linux'
	[gpui_macos]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_macos'
	[gpui_macros]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_macros'
	[gpui_platform]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_platform'
	[gpui_shared_string]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_shared_string'
	[gpui_util]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_util'
	[gpui_web]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_web'
	[gpui_wgpu]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_wgpu'
	[gpui_windows]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/gpui_windows'
	[http_client]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/http_client'
	[media]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/media'
	[naga]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/naga'
	[perf]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/tooling/perf'
	[proptest-macro]='https://github.com/proptest-rs/proptest;3dca198a8fef1b32e3a66f1e1897c955b4dc5b5b;proptest-%commit%/proptest-macro'
	[proptest]='https://github.com/proptest-rs/proptest;3dca198a8fef1b32e3a66f1e1897c955b4dc5b5b;proptest-%commit%/proptest'
	[refineable]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/refineable'
	[scheduler]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/scheduler'
	[sum_tree]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/sum_tree'
	[util]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/util'
	[util_macros]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/util_macros'
	[wgpu-core-deps-apple]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu-core/platform-deps/apple'
	[wgpu-core-deps-emscripten]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu-core/platform-deps/emscripten'
	[wgpu-core-deps-windows-linux-android]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu-core/platform-deps/windows-linux-android'
	[wgpu-core]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu-core'
	[wgpu-hal]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu-hal'
	[wgpu-naga-bridge]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu-naga-bridge'
	[wgpu-types]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu-types'
	[wgpu]='https://github.com/zed-industries/wgpu;357a0c56e0070480ad9daea5d2eaa83150b79e88;wgpu-%commit%/wgpu'
	[xim-ctext]='https://github.com/zed-industries/xim-rs;16f35a2c881b815a2b6cdfd6687988e84f8447d8;xim-rs-%commit%/xim-ctext'
	[xim-parser]='https://github.com/zed-industries/xim-rs;16f35a2c881b815a2b6cdfd6687988e84f8447d8;xim-rs-%commit%/xim-parser'
	[zed-font-kit]='https://github.com/zed-industries/font-kit;94b0f28166665e8fd2f53ff6d268a14955c82269;font-kit-%commit%'
	[zed-reqwest]='https://github.com/zed-industries/reqwest;c15662463bda39148ba154100dd44d3fba5873a4;reqwest-%commit%'
	[zed-scap]='https://github.com/zed-industries/scap;4afea48c3b002197176fb19cd0f9b180dd36eaac;scap-%commit%'
	[zed-xim]='https://github.com/zed-industries/xim-rs;16f35a2c881b815a2b6cdfd6687988e84f8447d8;xim-rs-%commit%'
	[zlog]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/zlog'
	[ztracing]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/ztracing'
	[ztracing_macro]='https://github.com/zed-industries/zed;1d217ee39d381ac101b7cf49d3d22451ac1093fe;zed-%commit%/crates/ztracing_macro'
)

inherit desktop cargo xdg

DESCRIPTION="Blazing-fast native Redis GUI built with Rust and GPUI"
HOMEPAGE="https://github.com/vicanso/zedis"
SRC_URI="https://github.com/vicanso/zedis/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/v${PV}/${P}-crates.tar.xz"

LICENSE="Apache-2.0"
# Dependent crate licenses
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 BSD Boost-1.0
	CC0-1.0 CDLA-Permissive-2.0 ISC MIT MPL-2.0 UoI-NCSA Unicode-3.0
	ZLIB BZIP2
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-arch/zstd:=
	>=dev-libs/libgit2-1.9.4:=
	x11-libs/libxcb:=
	x11-libs/libxkbcommon[wayland,X]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e '/Icon=/s/icon/zedis/' -i assets/zedis.desktop || die

	export ZSTD_SYS_USE_PKG_CONFIG=1
	export LIBGIT2_NO_VENDOR=1
	export VERGEN_GIT_SHA=${COMMIT}
}

src_install() {
	cargo_src_install
	domenu assets/zedis.desktop
	newicon assets/icon.png zedis.png
}
