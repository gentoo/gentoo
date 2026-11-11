# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, feature-rich, and cross-platform terminal emulator"
HOMEPAGE="https://ghostty.org/ https://github.com/ghostty-org/ghostty"

# FIXME: Zig build system currently requires us to include all packages
#        even if the build doesn't use them. Add a way in zig.eclass to
#        create empty package directories (this might need patching the
#        .zon files as well) which will allow us to avoid downloading
#        unused dependencies.
#
#        In this particular case, we're downloading iTerm2 color
#        schemes which have license issues. Binpkgs shouldn't be
#        affected but source builds will be.
_iterm2_color_schemes_uri="https://deps.files.ghostty.org/ghostty-themes-release-20261019-151001-86a776d.tgz"

# NOTE: Keep in sync with x11-terms/ghostty-terminfo ebuilds.
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
	[N-V-__8AAJ3vBQAq1fLMh5J8uWLkeDLS6WAdR2x5KcrmEyz6.tgz]="${_iterm2_color_schemes_uri}"
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
ZIG_NEEDS_LLVM=1
inherit zig xdg

SRC_URI="
	https://release.files.ghostty.org/${PV}/ghostty-${PV}.tar.gz

	https://github.com/sin-ack/gentoo-vendor/releases/download/ghostty-${PV}/ghostty-${PV}-vendor.tar.gz

	${ZBS_DEPENDENCIES_SRC_URI}
"

LICENSE="Apache-2.0 BSD BSD-2 BSD-4 Boost-1.0 MIT MPL-2.0 Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

# TODO: spirv-cross integration (missing Gentoo package)
COMMON_DEPEND="
	>=dev-libs/oniguruma-6.9.9:=
	>=dev-util/glslang-1.3.296.0:=
	gui-libs/gtk:4=[X?]
	gui-libs/libadwaita:1=
	media-libs/fontconfig:=
	media-libs/freetype:=[bzip2,harfbuzz,png]
	media-libs/harfbuzz:=[truetype,introspection]
	dev-cpp/highway:=
	>=dev-cpp/simdutf-9.0.0:=
	X? ( x11-libs/libX11 )
	wayland? (
		dev-libs/wayland
		gui-libs/gtk4-layer-shell:=
	)
	nls? ( virtual/libintl )
"
DEPEND="${COMMON_DEPEND}"
RDEPEND="
	${COMMON_DEPEND}
	~x11-terms/ghostty-terminfo-${PV}
"
BDEPEND="
	|| (
		>=dev-lang/zig-bin-0.17.1:${ZIG_SLOT}
		>=dev-lang/zig-0.17.1:${ZIG_SLOT}
	)
	man? ( virtual/pandoc )
	nls? ( sys-devel/gettext )
"

IUSE="X wayland man nls"
REQUIRED_USE="
	|| ( X wayland )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-bzip2-dependency.patch
	"${FILESDIR}"/${PN}-1.4.0-build-disable-terminfo-database-installation.patch
	# Make it possible to use the simdutf system integration on
	# AVX512 systems.
	# See: https://github.com/ghostty-org/ghostty/issues/15155
	# Source: https://github.com/ghostty-org/ghostty/commit/cf5519b22f910ddc7885d2ef62deb94d38d43f22
	"${FILESDIR}"/${PN}-1.4.0-simdutf-fix-AVX512-builds.patch
	# Do not install libghostty-vt (pkg-config files) from app builds, it is
	# provided by dev-libs/libghostty-vt.
	# Source: https://github.com/ghostty-org/ghostty/commit/184b01ab32c67b6accea14aa22ce8ed2c0ed7733
	"${FILESDIR}"/${PN}-1.4.0-libghostty-install-a-CMake-package-config-and-fix-li.patch
)

src_configure() {
	local my_zbs_args=(
		# XXX: Ghostty displays a banner saying it is a debug build unless ReleaseFast is used.
		-Doptimize=fast

		-Dapp-runtime=gtk
		-Demit-lib-vt=false
		-Dfont-backend=fontconfig_freetype
		-Drenderer=opengl
		-Dsentry=false
		-Dsimd=true
		-Dgtk-x11=$(usex X true false)
		-Dgtk-wayland=$(usex wayland true false)
		-Di18n=$(usex nls true false)
		-Demit-docs=$(usex man true false)
		-Dstrip=false
		-Dversion-string="${PV}"
		-Demit-terminfo=false
		-Demit-termcap=false
		# https://github.com/mbadolato/iTerm2-Color-Schemes/issues/638
		# TODO: Re-evaluate including themes once themes with bad licenses are removed.
		-Demit-themes=false

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
		-fsys=highway

		# See TODO above COMMON_DEPEND
		-fno-sys=spirv-cross
	)

	zig_src_configure
}

src_test() {
	# XXX: Ghostty requires that tests are run in Debug mode.
	local my_zbs_args=("${ZBS_ARGS[@]}")
	for i in "${!my_zbs_args[@]}"; do
		if [[ "${my_zbs_args[i]}" =~ -Doptimize=* ]]; then
			unset 'my_zbs_args[i]'
		fi
	done

	einfo "Testing with: ${my_zbs_args[@]}"
	DESTDIR="${BUILD_DIR}" nonfatal ezig build test "${my_zbs_args[@]}" || die "Running tests failed!"
}

pkg_postinst() {
	ewarn "This build of Ghostty does not include bundled iTerm2 color schemes,"
	ewarn "due to uncertainty around theme licensing:"
	ewarn ""
	ewarn "    https://github.com/mbadolato/iTerm2-Color-Schemes/issues/638"
	ewarn ""
	ewarn "Ghostty looks up themes in ~/.config/ghostty/themes/ by default,"
	ewarn "so to avoid breakage you can manually install the color schemes:"
	ewarn ""
	ewarn "    mkdir -p ~/.config/ghostty/themes/"
	ewarn "    wget -O- ${_iterm2_color_schemes_uri} | tar xz -C ~/.config/ghostty/themes/ --strip-components=1"
}
