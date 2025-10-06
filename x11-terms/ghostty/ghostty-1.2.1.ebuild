# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, feature-rich, and cross-platform terminal emulator"
HOMEPAGE="https://ghostty.org/ https://github.com/ghostty-org/ghostty"

# NOTE: Keep in sync with x11-terms/ghostty-terminfo ebuilds.
declare -g -r -A ZBS_DEPENDENCIES=(
	[N-V-__8AAAzZywE3s51XfsLbP9eyEw57ae9swYB9aGB6fCMs.tar.gz]='https://deps.files.ghostty.org/wuffs-122037b39d577ec2db3fd7b2130e7b69ef6cc1807d68607a7c232c958315d381b5cd.tar.gz'
	[N-V-__8AAB0eQwD-0MdOEBmz7intriBReIsIDNlukNVoNu6o.tar.gz]='https://deps.files.ghostty.org/zlib-1220fed0c74e1019b3ee29edae2051788b080cd96e90d56836eea857b0b966742efb.tar.gz'
	[N-V-__8AAB9YCQBaZtQjJZVndk-g_GDIK-NTZcIa63bFp9yZ.tar.gz]='https://deps.files.ghostty.org/zig_js-12205a66d423259567764fa0fc60c82be35365c21aeb76c5a7dc99698401f4f6fefc.tar.gz'
	[N-V-__8AABzkUgISeKGgXAzgtutgJsZc0-kkeqBBscJgMkvy.tar.gz]='https://deps.files.ghostty.org/glslang-12201278a1a05c0ce0b6eb6026c65cd3e9247aa041b1c260324bf29cee559dd23ba1.tar.gz'
	[N-V-__8AADYiAAB_80AWnH1AxXC0tql9thT-R-DYO1gBqTLc.tar.gz]='https://deps.files.ghostty.org/pixels-12207ff340169c7d40c570b4b6a97db614fe47e0d83b5801a932dcd44917424c8806.tar.gz'
	[N-V-__8AADcZkgn4cMhTUpIz6mShCKyqqB-NBtf_S2bHaTC-.tar.gz]='https://deps.files.ghostty.org/gettext-0.24.tar.gz'
	[N-V-__8AAG02ugUcWec-Ndp-i7JTsJ0dgF8nnJRUInkGLG7G.tar.xz]='https://deps.files.ghostty.org/harfbuzz-11.0.0.tar.xz'
	[N-V-__8AAG3RoQEyRC2Vw7Qoro5SYBf62IHn3HjqtNVY6aWK.tar.gz]='https://deps.files.ghostty.org/libxml2-2.11.5.tar.gz'
	[N-V-__8AAGmZhABbsPJLfbqrh6JTHsXhY6qCaLAQyx25e0XE.tar.gz]='https://deps.files.ghostty.org/highway-66486a10623fa0d72fe91260f96c892e41aceb06.tar.gz'
	[N-V-__8AAH0GaQC8a52s6vfIxg88OZgFgEW6DFxfSK4lX_l3.tar.gz]='https://deps.files.ghostty.org/imgui-1220bc6b9daceaf7c8c60f3c3998058045ba0c5c5f48ae255ff97776d9cd8bfc6402.tar.gz'
	[N-V-__8AAHffAgDU0YQmynL8K35WzkcnMUmBVQHQ0jlcKpjH.tar.gz]='https://deps.files.ghostty.org/utfcpp-1220d4d18426ca72fc2b7e56ce47273149815501d0d2395c2a98c726b31ba931e641.tar.gz'
	[N-V-__8AAHjwMQDBXnLq3Q2QhaivE0kE2aD138vtX2Bq1g7c.tar.gz]='https://deps.files.ghostty.org/oniguruma-1220c15e72eadd0d9085a8af134904d9a0f5dfcbed5f606ad60edc60ebeccd9706bb.tar.gz'
	[N-V-__8AAIC5lwAVPJJzxnCAahSvZTIlG-HhtOvnM1uh-66x.tar.gz]='https://deps.files.ghostty.org/JetBrainsMono-2.304.tar.gz'
	[N-V-__8AAIrfdwARSa-zMmxWwFuwpXf1T3asIN7s5jqi9c1v.tar.gz]='https://deps.files.ghostty.org/fontconfig-2.14.2.tar.gz'
	[N-V-__8AAJrvXQCqAT8Mg9o_tk6m0yf5Fz-gCNEOKLyTSerD.tar.gz]='https://deps.files.ghostty.org/libpng-1220aa013f0c83da3fb64ea6d327f9173fa008d10e28bc9349eac3463457723b1c66.tar.gz'
	[N-V-__8AAKLKpwC4H27Ps_0iL3bPkQb-z6ZVSrB-x_3EEkub.tar.gz]='https://deps.files.ghostty.org/freetype-1220b81f6ecfb3fd222f76cf9106fecfa6554ab07ec7fdc4124b9bb063ae2adf969d.tar.gz'
	[N-V-__8AAKYZBAB-CFHBKs3u4JkeiT4BMvyHu3Y5aaWF3Bbs.tar.gz]='https://deps.files.ghostty.org/plasma_wayland_protocols-12207e0851c12acdeee0991e893e0132fc87bb763969a585dc16ecca33e88334c566.tar.gz'
	[N-V-__8AAKrHGAAs2shYq8UkE6bGcR1QJtLTyOE_lcosMn6t.tar.gz]='https://deps.files.ghostty.org/wayland-9cb3d7aa9dc995ffafdbdef7ab86a949d0fb0e7d.tar.gz'
	[N-V-__8AAKw-DAAaV8bOAAGqA0-oD7o-HNIlPFYKRXSPT03S.tar.gz]='https://deps.files.ghostty.org/wayland-protocols-258d8f88f2c8c25a830c6316f87d23ce1a0f12d9.tar.gz'
	[N-V-__8AALiNBAA-_0gprYr92CjrMj1I5bqNu0TSJOnjFNSr.tar.gz]='https://deps.files.ghostty.org/gtk4-layer-shell-1.1.0.tar.gz'
	[N-V-__8AALw2uwF_03u4JRkZwRLc3Y9hakkYV7NKRR9-RIZJ.tar.gz]='https://deps.files.ghostty.org/breakpad-b99f444ba5f6b98cac261cbb391d8766b34a5918.tar.gz'
	[N-V-__8AAMVLTABmYkLqhZPLXnMl-KyN38R8UVYqGrxqO26s.tar.gz]='https://deps.files.ghostty.org/NerdFontsSymbolsOnly-3.4.0.tar.gz'
	[N-V-__8AANb6pwD7O1WG6L5nvD_rNMvnSc9Cpg1ijSlTYywv.tar.gz]='https://deps.files.ghostty.org/spirv_cross-1220fb3b5586e8be67bc3feb34cbe749cf42a60d628d2953632c2f8141302748c8da.tar.gz'
	[N-V-__8AALIsAwDyo88G5mGJGN2lSVmmFMx4YePfUvp_2o3Y.tar.gz]='https://github.com/mbadolato/iTerm2-Color-Schemes/releases/download/release-20251002-142451-4a5043e/ghostty-themes.tgz'
	[N-V-__8AAPlZGwBEa-gxrcypGBZ2R8Bse4JYSfo_ul8i2jlG.tar.gz]='https://deps.files.ghostty.org/sentry-1220446be831adcca918167647c06c7b825849fa3fba5f22da394667974537a9c77e.tar.gz'
	[gobject-0.3.0-Skun7ET3nQAc0LzvO0NAvTiGGnmkF36cnmbeCAF6MB7Z.tar.zst]='https://github.com/jcollie/ghostty-gobject/releases/download/0.15.1-2025-09-04-48-1/ghostty-gobject-0.15.1-2025-09-04-48-1.tar.zst'
	[libxev-0.0.0-86vtc2UaEwDfiTKX3iBI-s_hdzfzWQUarT3MUrmUQl-Q.tar.gz]='https://github.com/mitchellh/libxev/archive/7f803181b158a10fec8619f793e3b4df515566cb.tar.gz'
	[vaxis-0.1.0-BWNV_FUICQAFZnTCL11TUvnUr1Y0_ZdqtXHhd51d76Rn.tar.gz]='https://github.com/rockorager/libvaxis/archive/1f41c121e8fc153d9ce8c6eb64b2bbab68ad7d23.tar.gz'
	[wayland-0.4.0-dev-lQa1kjfIAQCmhhQu3xF0KH-94-TzeMXOqfnP0-Dg6Wyy.tar.gz]='https://codeberg.org/ifreund/zig-wayland/archive/f3c5d503e540ada8cbcb056420de240af0c094f7.tar.gz'
	[z2d-0.8.1-j5P_Hq8vDwB8ZaDA54-SzESDLF2zznG_zvTHiQNJImZP.tar.gz]='https://github.com/vancluever/z2d/archive/refs/tags/v0.8.1.tar.gz'
	[zf-0.10.3-OIRy8aiIAACLrBllz0zjxaH0aOe5oNm3KtEMyCntST-9.tar.gz]='https://github.com/natecraddock/zf/archive/7aacbe6d155d64d15937ca95ca6c014905eb531f.tar.gz'
	[zg-0.13.4-AAAAAGiZ7QLz4pvECFa_wG4O4TP4FLABHHbemH2KakWM.tar.gz]='https://codeberg.org/atman/zg/archive/4a002763419a34d61dcbb1f415821b83b9bf8ddc.tar.gz'
	[zig_objc-0.0.0-Ir_SpwsPAQBJgi9YRm2ubJMfdoysSq5gKpsIj3izQ8Zk.tar.gz]='https://github.com/mitchellh/zig-objc/archive/c9e917a4e15a983b672ca779c7985d738a2d517c.tar.gz'
	[zigimg-0.1.0-lly-O6N2EABOxke8dqyzCwhtUCAafqP35zC7wsZ4Ddxj.tar.gz]='https://github.com/TUSF/zigimg/archive/31268548fe3276c0e95f318a6c0d2ab10565b58d.tar.gz'
	[ziglyph-0.11.2-AAAAAHPtHwB4Mbzn1KvOV7Wpjo82NYEc_v0WC8oCLrkf.tar.gz]='https://deps.files.ghostty.org/ziglyph-b89d43d1e3fb01b6074bc1f7fc980324b04d26a5.tar.gz'
)

ZIG_SLOT="0.14"
ZIG_NEEDS_LLVM=1
inherit zig xdg

SRC_URI="
	https://release.files.ghostty.org/${PV}/ghostty-${PV}.tar.gz
	${ZBS_DEPENDENCIES_SRC_URI}
"

LICENSE="Apache-2.0 BSD BSD-2 BSD-4 Boost-1.0 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

# TODO: simdutf integration (missing Gentoo version)
# TODO: spirv-cross integration (missing Gentoo package)
COMMON_DEPEND="
	>=dev-libs/oniguruma-6.9.9:=
	>=dev-util/glslang-1.3.296.0:=
	gui-libs/gtk:4=[X?]
	gui-libs/libadwaita:1=
	>=media-libs/fontconfig-2.14.2:=
	>=media-libs/freetype-2.13.2:=[bzip2,harfbuzz,png]
	>=media-libs/harfbuzz-8.4.0:=[truetype]
	X? ( x11-libs/libX11 )
	wayland? (
		dev-libs/wayland
		gui-libs/gtk4-layer-shell:=
	)
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="
	${COMMON_DEPEND}
	~x11-terms/ghostty-terminfo-${PV}
"
BDEPEND="
	man? ( virtual/pandoc )
"

IUSE="X wayland man"
REQUIRED_USE="
	|| ( X wayland )
"

# zig build test fails for this release (under investigation)
# https://github.com/ghostty-org/ghostty/discussions/8676
RESTRICT="test"

# XXX: Because we set --release=fast below, Zig will automatically strip
#      the binary. Until Ghostty provides a way to disable the banner while
#      having debug symbols we have ignore pre-stripped file warnings.
QA_PRESTRIPPED="usr/bin/ghostty"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.0-bzip2-dependency.patch
	"${FILESDIR}"/${PN}-1.2.0-build-disable-terminfo-database-installation.patch
)

src_configure() {
	local my_zbs_args=(
		# XXX: Ghostty displays a banner saying it is a debug build unless ReleaseFast is used.
		--release=fast

		-Dapp-runtime=gtk
		-Dfont-backend=fontconfig_freetype
		-Drenderer=opengl
		-Dgtk-x11=$(usex X true false)
		-Dgtk-wayland=$(usex wayland true false)
		-Demit-docs=$(usex man true false)
		-Dversion-string="${PV}"
		-Demit-terminfo=false
		-Demit-termcap=false

		-fsys=freetype
		-fsys=harfbuzz
		-fsys=fontconfig
		-fsys=libpng
		-fsys=zlib
		-fsys=oniguruma
		-fsys=glslang
		-fsys=spirv-cross
		-fsys=simdutf
		-fsys=gtk4-layer-shell

		# See TODO above COMMON_DEPEND
		-fno-sys=spirv-cross
		-fno-sys=simdutf
	)

	zig_src_configure
}
