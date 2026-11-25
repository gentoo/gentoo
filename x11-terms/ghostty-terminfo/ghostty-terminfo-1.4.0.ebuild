# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terminfo for ghostty, a fast, feature-rich, and cross-platform terminal emulator"
HOMEPAGE="https://ghostty.org/ https://github.com/ghostty-org/ghostty"

# NOTE: Keep in sync with x11-terms/ghostty ebuilds.
declare -g -r -A ZBS_DEPENDENCIES=(
	[N-V-__8AAB0eQwD-0MdOEBmz7intriBReIsIDNlukNVoNu6o.tar.gz]='https://deps.files.ghostty.org/zlib-1220fed0c74e1019b3ee29edae2051788b080cd96e90d56836eea857b0b966742efb.tar.gz'
	[N-V-__8AABzkUgISeKGgXAzgtutgJsZc0-kkeqBBscJgMkvy.tar.gz]='https://deps.files.ghostty.org/glslang-12201278a1a05c0ce0b6eb6026c65cd3e9247aa041b1c260324bf29cee559dd23ba1.tar.gz'
	[N-V-__8AADYiAAB_80AWnH1AxXC0tql9thT-R-DYO1gBqTLc.tar.gz]='https://deps.files.ghostty.org/pixels-12207ff340169c7d40c570b4b6a97db614fe47e0d83b5801a932dcd44917424c8806.tar.gz'
	[N-V-__8AADcZkgn4cMhTUpIz6mShCKyqqB-NBtf_S2bHaTC-.tar.gz]='https://deps.files.ghostty.org/gettext-0.24.tar.gz'
	[N-V-__8AAEbOfQBnvcFcCX2W5z7tDaN8vaNZGamEQtNOe0UI.tar.gz]='https://deps.files.ghostty.org/N-V-__8AAEbOfQBnvcFcCX2W5z7tDaN8vaNZGamEQtNOe0UI.tar.gz'
	[N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA.tar.gz]='https://deps.files.ghostty.org/N-V-__8AAFdWDwA0ktbNUi9pFBHCRN4weXIgIfCrVjfGxqgA.tar.gz'
	[N-V-__8AAG02ugUcWec-Ndp-i7JTsJ0dgF8nnJRUInkGLG7G.tar.xz]='https://deps.files.ghostty.org/harfbuzz-11.0.0.tar.xz'
	[N-V-__8AAG3RoQEyRC2Vw7Qoro5SYBf62IHn3HjqtNVY6aWK.tar.gz]='https://deps.files.ghostty.org/libxml2-2.11.5.tar.gz'
	[N-V-__8AAGmZhABbsPJLfbqrh6JTHsXhY6qCaLAQyx25e0XE.tar.gz]='https://deps.files.ghostty.org/highway-66486a10623fa0d72fe91260f96c892e41aceb06.tar.gz'
	[N-V-__8AAHjwMQDBXnLq3Q2QhaivE0kE2aD138vtX2Bq1g7c.tar.gz]='https://deps.files.ghostty.org/oniguruma-1220c15e72eadd0d9085a8af134904d9a0f5dfcbed5f606ad60edc60ebeccd9706bb.tar.gz'
	[N-V-__8AAIC5lwAVPJJzxnCAahSvZTIlG-HhtOvnM1uh-66x.tar.gz]='https://deps.files.ghostty.org/JetBrainsMono-2.304.tar.gz'
	[N-V-__8AAJ3vBQAq1fLMh5J8uWLkeDLS6WAdR2x5KcrmEyz6.tgz]='https://deps.files.ghostty.org/ghostty-themes-release-20261019-151001-86a776d.tgz'
	[N-V-__8AAJrvXQCqAT8Mg9o_tk6m0yf5Fz-gCNEOKLyTSerD.tar.gz]='https://deps.files.ghostty.org/libpng-1220aa013f0c83da3fb64ea6d327f9173fa008d10e28bc9349eac3463457723b1c66.tar.gz'
	[N-V-__8AAKLKpwC4H27Ps_0iL3bPkQb-z6ZVSrB-x_3EEkub.tar.gz]='https://deps.files.ghostty.org/freetype-1220b81f6ecfb3fd222f76cf9106fecfa6554ab07ec7fdc4124b9bb063ae2adf969d.tar.gz'
	[N-V-__8AAKYZBAB-CFHBKs3u4JkeiT4BMvyHu3Y5aaWF3Bbs.tar.gz]='https://deps.files.ghostty.org/plasma_wayland_protocols-12207e0851c12acdeee0991e893e0132fc87bb763969a585dc16ecca33e88334c566.tar.gz'
	[N-V-__8AAKrHGAAs2shYq8UkE6bGcR1QJtLTyOE_lcosMn6t.tar.gz]='https://deps.files.ghostty.org/wayland-9cb3d7aa9dc995ffafdbdef7ab86a949d0fb0e7d.tar.gz'
	[N-V-__8AAKw-DAAaV8bOAAGqA0-oD7o-HNIlPFYKRXSPT03S.tar.gz]='https://deps.files.ghostty.org/wayland-protocols-258d8f88f2c8c25a830c6316f87d23ce1a0f12d9.tar.gz'
	[N-V-__8AALiNBAA-_0gprYr92CjrMj1I5bqNu0TSJOnjFNSr.tar.gz]='https://deps.files.ghostty.org/gtk4-layer-shell-1.1.0.tar.gz'
	[N-V-__8AALw2uwF_03u4JRkZwRLc3Y9hakkYV7NKRR9-RIZJ.tar.gz]='https://deps.files.ghostty.org/breakpad-b99f444ba5f6b98cac261cbb391d8766b34a5918.tar.gz'
	[N-V-__8AAMVLTABmYkLqhZPLXnMl-KyN38R8UVYqGrxqO26s.tar.gz]='https://deps.files.ghostty.org/NerdFontsSymbolsOnly-3.4.0.tar.gz'
	[N-V-__8AANT61wB--nJ95Gj_ctmzAtcjloZ__hRqNw5lC1Kr.tar.gz]='https://deps.files.ghostty.org/DearBindings_v0.17_ImGui_v1.92.5-docking.tar.gz'
	[N-V-__8AANb6pwD7O1WG6L5nvD_rNMvnSc9Cpg1ijSlTYywv.tar.gz]='https://deps.files.ghostty.org/spirv_cross-1220fb3b5586e8be67bc3feb34cbe749cf42a60d628d2953632c2f8141302748c8da.tar.gz'
	[N-V-__8AAOgqbADacob-q2_DMQlmgaG4xKHRuW-6PJ4oJzMZ.tar.xz]='https://deps.files.ghostty.org/N-V-__8AAOgqbADacob-q2_DMQlmgaG4xKHRuW-6PJ4oJzMZ.tar.xz'
	[N-V-__8AAP5JWgCGP_AD0teWpa4krRvE9VPZzvviGdbmN4jI.tar.gz]='https://deps.files.ghostty.org/wuffs-7411f488fe2e2c205c3d3b3d28638b7356522930.tar.gz'
	[N-V-__8AAPlZGwBEa-gxrcypGBZ2R8Bse4JYSfo_ul8i2jlG.tar.gz]='https://deps.files.ghostty.org/sentry-1220446be831adcca918167647c06c7b825849fa3fba5f22da394667974537a9c77e.tar.gz'
	[gobject-0.3.2-Skun7LuIogBbEh-6WrLeEzMaRCnOMB3eOf__RaPYSMCZ.tar.zst]='https://deps.files.ghostty.org/gobject-2026-10-02-38-1.tar.zst'
	[libxev-0.0.0-86vtc8QQFACz0sVc7U-VDiDIgH-XfBuEY5JpABLjHNpn.tar.gz]='https://deps.files.ghostty.org/libxev-819ffa180ca20e31c7eded74e2e1aceb1eab557f.tar.gz'
	[translate_c-2.0.0-Q_BUWltOBwBYABF84EUL208pIFeUIwbBs29FmVBaafN5.tar.gz]='https://deps.files.ghostty.org/translate_c-02ff0c523fb92a38939b04d0145c4a9602a74d56.tar.gz'
	[uucode-0.2.0-ZZjBPoGFVgCiflJNFc6Io8xzC67B6PA5bUkk4LT0kCxg.tar.gz]='https://deps.files.ghostty.org/uucode-ea62149739404a73c202b48a33bf6dd2af4bd9b0.tar.gz'
	[vaxis-0.6.0-BWNV_MafDAAEzkVUvrW9NFUqnnMUoeHqrs2mecnD6D7w.tar.gz]='https://deps.files.ghostty.org/vaxis-6fd944a27fb3d6f596e981076381a3131f2448b4.tar.gz'
	[wayland-0.7.0-dev-lQa1klz9AQB87V0pMKMdm8JvyOx32XR9FxcWnw9wh6XZ.tar.gz]='https://deps.files.ghostty.org/zig_wayland-27dda01712ddf3cb46ebd93380d88b01a7c828f8.tar.gz'
	[z2d-0.13.0-j5P_HgsRFABzZDH54gI35P0OSrg7HFyJwS2bXX5uBdU4.tar.gz]='https://deps.files.ghostty.org/z2d-40af3e84a4e15a9f31d126b3f281f23ce6a3dae5.tar.gz'
	[zf-0.11.0-OIRy8XCRAAB6FiMwIrtD6FqlagnFwpI6YyOu7bXeYH5J.tar.gz]='https://deps.files.ghostty.org/zf-87153bb86b75d21fbac897b738f316d449f5d0c9.tar.gz'
	[zig_js-0.0.0-rjCAV7-GAADvMTBL7lPMuvDk7xgS9PCMIZWiOUXLZSlj.tar.gz]='https://deps.files.ghostty.org/zig_js-3c23860e47fdcdc5af805efb7fd0bdac5fd3e9bc.tar.gz'
	[zig_objc-0.0.0-Ir_Sp_4tAQDXtPi51nW_jD9LOEzBvU9lofwO9Pzi6IB4.tar.gz]='https://deps.files.ghostty.org/zig_objc-3352c12a868f8787ab71bf2ca6eab9fcfb635c52.tar.gz'

	# Git dependencies
	[aro-0.0.0-JSD1QtuBNwCASyBtNF3pqTl_W3oAJQGEVyFAtrBSE_Pa.tar.gz]=''
	[zigimg-0.1.0-8_eo2ri_FwBqF5UYiggLz4IGjHJO_n9-B6gT9Ayqg8G4.tar.gz]=''
)

ZIG_SLOT="0.17"
inherit zig

SRC_URI="
	https://release.files.ghostty.org/${PV}/ghostty-${PV}.tar.gz

	https://github.com/sin-ack/gentoo-vendor/releases/download/ghostty-${PV}/ghostty-${PV}-vendor.tar.gz

	${ZBS_DEPENDENCIES_SRC_URI}
"
S="${WORKDIR}/${P/-terminfo/}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="symlink"
# Tests are run on the main Ghostty package.
RESTRICT="test"

RDEPEND="
	symlink? ( sys-libs/ncurses[minimal] )
	!symlink? ( sys-libs/ncurses[-minimal] )
"
BDEPEND="
	sys-libs/ncurses
	|| (
		>=dev-lang/zig-bin-0.17.1
		>=dev-lang/zig-0.17.1
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-build-add-a-step-for-only-building-terminfo.patch
)

src_configure() {
	local my_zbs_args=(
		-Demit-terminfo=false
		-Demit-termcap=false
	)

	zig_src_configure
}

src_compile() {
	:
}

src_install() {
	DESTDIR="${D}" nonfatal ezig build terminfo "${ZBS_ARGS[@]}" \
		|| die "Failed to compile terminfo database"

	# Newer ncurses versions have a "ghostty" terminfo entry which
	# collides with the "ghostty" symlink that is installed by default,
	# but only when USE=-minimal. Remove the symlink in that case.
	if ! use symlink; then
		rm -rf "${ED}/usr/share/terminfo/g" || die
	fi
}
