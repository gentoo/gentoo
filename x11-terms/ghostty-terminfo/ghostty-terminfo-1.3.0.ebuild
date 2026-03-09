# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terminfo for ghostty, a fast, feature-rich, and cross-platform terminal emulator"
HOMEPAGE="https://ghostty.org/ https://github.com/ghostty-org/ghostty"

# NOTE: Keep in sync with x11-terms/ghostty ebuilds.
declare -g -r -A ZBS_DEPENDENCIES=(
	[N-V-__8AAAzZywE3s51XfsLbP9eyEw57ae9swYB9aGB6fCMs.tar.gz]='https://deps.files.ghostty.org/wuffs-122037b39d577ec2db3fd7b2130e7b69ef6cc1807d68607a7c232c958315d381b5cd.tar.gz'
	[N-V-__8AAB0eQwD-0MdOEBmz7intriBReIsIDNlukNVoNu6o.tar.gz]='https://deps.files.ghostty.org/zlib-1220fed0c74e1019b3ee29edae2051788b080cd96e90d56836eea857b0b966742efb.tar.gz'
	[N-V-__8AABVbAwBwDRyZONfx553tvMW8_A2OKUoLzPUSRiLF.tar.gz]="https://deps.files.ghostty.org/ghostty-themes-release-20260216-151611-fc73ce3.tgz"
	[N-V-__8AABzkUgISeKGgXAzgtutgJsZc0-kkeqBBscJgMkvy.tar.gz]='https://deps.files.ghostty.org/glslang-12201278a1a05c0ce0b6eb6026c65cd3e9247aa041b1c260324bf29cee559dd23ba1.tar.gz'
	[N-V-__8AADYiAAB_80AWnH1AxXC0tql9thT-R-DYO1gBqTLc.tar.gz]='https://deps.files.ghostty.org/pixels-12207ff340169c7d40c570b4b6a97db614fe47e0d83b5801a932dcd44917424c8806.tar.gz'
	[N-V-__8AADcZkgn4cMhTUpIz6mShCKyqqB-NBtf_S2bHaTC-.tar.gz]='https://deps.files.ghostty.org/gettext-0.24.tar.gz'
	[N-V-__8AAEbOfQBnvcFcCX2W5z7tDaN8vaNZGamEQtNOe0UI.tar.gz]='https://github.com/ocornut/imgui/archive/refs/tags/v1.92.5-docking.tar.gz'
	[N-V-__8AAG02ugUcWec-Ndp-i7JTsJ0dgF8nnJRUInkGLG7G.tar.xz]='https://deps.files.ghostty.org/harfbuzz-11.0.0.tar.xz'
	[N-V-__8AAG3RoQEyRC2Vw7Qoro5SYBf62IHn3HjqtNVY6aWK.tar.gz]='https://deps.files.ghostty.org/libxml2-2.11.5.tar.gz'
	[N-V-__8AAGmZhABbsPJLfbqrh6JTHsXhY6qCaLAQyx25e0XE.tar.gz]='https://deps.files.ghostty.org/highway-66486a10623fa0d72fe91260f96c892e41aceb06.tar.gz'
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
	[N-V-__8AANT61wB--nJ95Gj_ctmzAtcjloZ__hRqNw5lC1Kr.tar.gz]='https://deps.files.ghostty.org/DearBindings_v0.17_ImGui_v1.92.5-docking.tar.gz'
	[N-V-__8AANb6pwD7O1WG6L5nvD_rNMvnSc9Cpg1ijSlTYywv.tar.gz]='https://deps.files.ghostty.org/spirv_cross-1220fb3b5586e8be67bc3feb34cbe749cf42a60d628d2953632c2f8141302748c8da.tar.gz'
	[N-V-__8AAPlZGwBEa-gxrcypGBZ2R8Bse4JYSfo_ul8i2jlG.tar.gz]='https://deps.files.ghostty.org/sentry-1220446be831adcca918167647c06c7b825849fa3fba5f22da394667974537a9c77e.tar.gz'
	[gobject-0.3.0-Skun7ANLnwDvEfIpVmohcppXgOvg_I6YOJFmPIsKfXk-.tar.zst]='https://deps.files.ghostty.org/gobject-2025-11-08-23-1.tar.zst'
	[libxev-0.0.0-86vtc4IcEwCqEYxEYoN_3KXmc6A9VLcm22aVImfvecYs.tar.gz]='https://deps.files.ghostty.org/libxev-34fa50878aec6e5fa8f532867001ab3c36fae23e.tar.gz'
	[uucode-0.1.0-ZZjBPj96QADXyt5sqwBJUnhaDYs_qBeeKijZvlRa0eqM.tar.gz]='https://github.com/jacobsandlund/uucode/archive/5f05f8f83a75caea201f12cc8ea32a2d82ea9732.tar.gz'
	[uucode-0.2.0-ZZjBPqZVVABQepOqZHR7vV_NcaN-wats0IB6o-Exj6m9.tar.gz]='https://deps.files.ghostty.org/uucode-0.2.0-ZZjBPqZVVABQepOqZHR7vV_NcaN-wats0IB6o-Exj6m9.tar.gz'
	[vaxis-0.5.1-BWNV_LosCQAGmCCNOLljCIw6j6-yt53tji6n6rwJ2BhS.tar.gz]='https://github.com/rockorager/libvaxis/archive/7dbb9fd3122e4ffad262dd7c151d80d863b68558.tar.gz'
	[wayland-0.5.0-dev-lQa1khrMAQDJDwYFKpdH3HizherB7sHo5dKMECfvxQHe.tar.gz]='https://deps.files.ghostty.org/zig_wayland-1b5c038ec10da20ed3a15b0b2a6db1c21383e8ea.tar.gz'
	[z2d-0.10.0-j5P_Hu-6FgBsZNgwphIqh17jDnj8_yPtD8yzjO6PpHRQ.tar.gz]='https://deps.files.ghostty.org/z2d-0.10.0-j5P_Hu-6FgBsZNgwphIqh17jDnj8_yPtD8yzjO6PpHRQ.tar.gz'
	[zf-0.10.3-OIRy8RuJAACKA3Lohoumrt85nRbHwbpMcUaLES8vxDnh.tar.gz]='https://deps.files.ghostty.org/zf-3c52637b7e937c5ae61fd679717da3e276765b23.tar.gz'
	[zig_js-0.0.0-rjCAV-6GAADxFug7rDmPH-uM_XcnJ5NmuAMJCAscMjhi.tar.gz]='https://deps.files.ghostty.org/zig_js-04db83c617da1956ac5adc1cb9ba1e434c1cb6fd.tar.gz'
	[zig_objc-0.0.0-Ir_Sp5gTAQCvxxR7oVIrPXxXwsfKgVP7_wqoOQrZjFeK.tar.gz]='https://deps.files.ghostty.org/zig_objc-f356ed02833f0f1b8e84d50bed9e807bf7cdc0ae.tar.gz'
	[zigimg-0.1.0-8_eo2vHnEwCIVW34Q14Ec-xUlzIoVg86-7FU2ypPtxms.tar.gz]='https://github.com/ivanstepanovftw/zigimg/archive/d7b7ab0ba0899643831ef042bd73289510b39906.tar.gz'
)

ZIG_SLOT="0.15"
inherit zig

SRC_URI="
	https://release.files.ghostty.org/${PV}/ghostty-${PV}.tar.gz
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
	>=dev-lang/zig-0.15.2
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.0-build-add-a-step-for-only-building-terminfo.patch
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
