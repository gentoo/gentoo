# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RUST_MIN_VER="1.93"
CRATES=""

declare -A GIT_CRATES=(
	[collections]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/collections'
	[derive_refineable]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/refineable/derive_refineable'
	[gpui-component-assets]='https://github.com/longbridge/gpui-component;311c7e0d104d817ed1ac9a1c7542d508df32f7cf;gpui-component-%commit%/crates/assets'
	[gpui-component-macros]='https://github.com/longbridge/gpui-component;311c7e0d104d817ed1ac9a1c7542d508df32f7cf;gpui-component-%commit%/crates/macros'
	[gpui-component]='https://github.com/longbridge/gpui-component;311c7e0d104d817ed1ac9a1c7542d508df32f7cf;gpui-component-%commit%/crates/ui'
	[gpui]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui'
	[gpui_linux]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_linux'
	[gpui_macos]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_macos'
	[gpui_macros]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_macros'
	[gpui_platform]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_platform'
	[gpui_util]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_util'
	[gpui_web]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_web'
	[gpui_wgpu]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_wgpu'
	[gpui_windows]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/gpui_windows'
	[http_client]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/http_client'
	[media]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/media'
	[naga]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/naga'
	[perf]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/tooling/perf'
	[refineable]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/refineable'
	[scheduler]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/scheduler'
	[sum_tree]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/sum_tree'
	[util]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/util'
	[util_macros]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/util_macros'
	[wgpu-core-deps-apple]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu-core/platform-deps/apple'
	[wgpu-core-deps-emscripten]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu-core/platform-deps/emscripten'
	[wgpu-core-deps-windows-linux-android]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu-core/platform-deps/windows-linux-android'
	[wgpu-core]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu-core'
	[wgpu-hal]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu-hal'
	[wgpu-naga-bridge]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu-naga-bridge'
	[wgpu-types]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu-types'
	[wgpu]='https://github.com/zed-industries/wgpu;a466bc382ea747f8e1ac810efdb6dcd49a514575;wgpu-%commit%/wgpu'
	[xim-ctext]='https://github.com/zed-industries/xim-rs;16f35a2c881b815a2b6cdfd6687988e84f8447d8;xim-rs-%commit%/xim-ctext'
	[xim-parser]='https://github.com/zed-industries/xim-rs;16f35a2c881b815a2b6cdfd6687988e84f8447d8;xim-rs-%commit%/xim-parser'
	[zed-font-kit]='https://github.com/zed-industries/font-kit;110523127440aefb11ce0cf280ae7c5071337ec5;font-kit-%commit%'
	[zed-reqwest]='https://github.com/zed-industries/reqwest;c15662463bda39148ba154100dd44d3fba5873a4;reqwest-%commit%'
	[zed-scap]='https://github.com/zed-industries/scap;4afea48c3b002197176fb19cd0f9b180dd36eaac;scap-%commit%'
	[zed-xim]='https://github.com/zed-industries/xim-rs;16f35a2c881b815a2b6cdfd6687988e84f8447d8;xim-rs-%commit%'
	[zlog]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/zlog'
	[ztracing]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/ztracing'
	[ztracing_macro]='https://github.com/zed-industries/zed;abec0efce8de9388506ea92341ded605c1e37e03;zed-%commit%/crates/ztracing_macro'
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
	ZLIB
"
# ring crate
LICENSE+=" openssl"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	app-arch/zstd:=
	x11-libs/libxcb:=
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed -e '/Icon=/s/icon/zedis/' -i assets/zedis.desktop || die

	export ZSTD_SYS_USE_PKG_CONFIG=1
}

src_install() {
	cargo_src_install
	domenu assets/zedis.desktop
	newicon assets/icon.png zedis.png
}
