# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Terminfo for ghostty, a fast, feature-rich, and cross-platform terminal emulator"
HOMEPAGE="https://ghostty.org/ https://github.com/ghostty-org/ghostty"

# NOTE: Keep in sync with x11-terms/ghostty ebuilds.
declare -g -r -A ZBS_DEPENDENCIES=(
	[breakpad-12207fd37bb8251919c112dcdd8f616a491857b34a451f7e4486490077206dc2a1ea.tar.gz]='https://github.com/getsentry/breakpad/archive/b99f444ba5f6b98cac261cbb391d8766b34a5918.tar.gz'
	[fontconfig-12201149afb3326c56c05bb0a577f54f76ac20deece63aa2f5cd6ff31a4fa4fcb3b7.tar.gz]='https://deps.files.ghostty.org/fontconfig-2.14.2.tar.gz'
	[freetype-1220b81f6ecfb3fd222f76cf9106fecfa6554ab07ec7fdc4124b9bb063ae2adf969d.tar.gz]='https://github.com/freetype/freetype/archive/refs/tags/VER-2-13-2.tar.gz'
	[glfw-1220736fa4ba211162c7a0e46cc8fe04d95921927688bff64ab5da7420d098a7272d.tar.gz]='https://github.com/mitchellh/glfw/archive/b552c6ec47326b94015feddb36058ea567b87159.tar.gz'
	[glslang-12201278a1a05c0ce0b6eb6026c65cd3e9247aa041b1c260324bf29cee559dd23ba1.tar.gz]='https://github.com/KhronosGroup/glslang/archive/refs/tags/14.2.0.tar.gz'
	[gobject-12208d70ee791d7ef7e16e1c3c9c1127b57f1ed066a24f87d57fc9f730c5dc394b9d.tar.zst]='https://github.com/ianprime0509/zig-gobject/releases/download/v0.2.2/bindings-gnome47.tar.zst'
	[harfbuzz-1220b8588f106c996af10249bfa092c6fb2f35fbacb1505ef477a0b04a7dd1063122.tar.gz]='https://github.com/harfbuzz/harfbuzz/archive/refs/tags/8.4.0.tar.gz'
	[highway-12205c83b8311a24b1d5ae6d21640df04f4b0726e314337c043cde1432758cbe165b.tar.gz]='https://github.com/google/highway/archive/refs/tags/1.1.0.tar.gz'
	[imgui-1220bc6b9daceaf7c8c60f3c3998058045ba0c5c5f48ae255ff97776d9cd8bfc6402.tar.gz]='https://github.com/ocornut/imgui/archive/e391fe2e66eb1c96b1624ae8444dc64c23146ef4.tar.gz'
	[iterm2_themes-12203d2647e5daf36a9c85b969e03f422540786ce9ea624eb4c26d204fe1f46218f3.tar.gz]='https://github.com/mbadolato/iTerm2-Color-Schemes/archive/db227d159adc265818f2e898da0f70ef8d7b580e.tar.gz'
	[libpng-1220aa013f0c83da3fb64ea6d327f9173fa008d10e28bc9349eac3463457723b1c66.tar.gz]='https://github.com/pnggroup/libpng/archive/refs/tags/v1.6.43.tar.gz'
	[libxev-1220ebf88622c4d502dc59e71347e4d28c47e033f11b59aff774ae5787565c40999c.tar.gz]='https://github.com/mitchellh/libxev/archive/31eed4e337fed7b0149319e5cdbb62b848c24fbd.tar.gz'
	[libxml2-122032442d95c3b428ae8e526017fad881e7dc78eab4d558e9a58a80bfbd65a64f7d.tar.gz]='https://github.com/GNOME/libxml2/archive/refs/tags/v2.11.5.tar.gz'
	[mach-glfw-12206ed982e709e565d536ce930701a8c07edfd2cfdce428683f3f2a601d37696a62.tar.gz]='https://github.com/mitchellh/mach-glfw/archive/37c2995f31abcf7e8378fba68ddcf4a3faa02de0.tar.gz'
	[oniguruma-1220c15e72eadd0d9085a8af134904d9a0f5dfcbed5f606ad60edc60ebeccd9706bb.tar.gz]='https://github.com/kkos/oniguruma/archive/refs/tags/v6.9.9.tar.gz'
	[pixels-12207ff340169c7d40c570b4b6a97db614fe47e0d83b5801a932dcd44917424c8806.tar.gz]='https://github.com/make-github-pseudonymous-again/pixels/archive/d843c2714d32e15b48b8d7eeb480295af537f877.tar.gz'
	[plasma_wayland_protocols-12207e0851c12acdeee0991e893e0132fc87bb763969a585dc16ecca33e88334c566.tar.gz]='https://github.com/KDE/plasma-wayland-protocols/archive/db525e8f9da548cffa2ac77618dd0fbe7f511b86.tar.gz'
	[sentry-1220446be831adcca918167647c06c7b825849fa3fba5f22da394667974537a9c77e.tar.gz]='https://github.com/getsentry/sentry-native/archive/refs/tags/0.7.8.tar.gz'
	[spirv_cross-1220fb3b5586e8be67bc3feb34cbe749cf42a60d628d2953632c2f8141302748c8da.tar.gz]='https://github.com/KhronosGroup/SPIRV-Cross/archive/476f384eb7d9e48613c45179e502a15ab95b6b49.tar.gz'
	[utfcpp-1220d4d18426ca72fc2b7e56ce47273149815501d0d2395c2a98c726b31ba931e641.tar.gz]='https://github.com/nemtrif/utfcpp/archive/refs/tags/v4.0.5.tar.gz'
	[vaxis-12200df4ebeaed45de26cb2c9f3b6f3746d8013b604e035dae658f86f586c8c91d2f.tar.gz]='https://github.com/rockorager/libvaxis/archive/6d729a2dc3b934818dffe06d2ba3ce02841ed74b.tar.gz'
	[vaxis-1220c72c1697dd9008461ead702997a15d8a1c5810247f02e7983b9f74c6c6e4c087.tar.gz]='https://github.com/rockorager/libvaxis/archive/dc0a228a5544988d4a920cfb40be9cd28db41423.tar.gz'
	[vulkan_headers-122004bfd4c519dadfb8e6281a42fc34fd1aa15aea654ea8a492839046f9894fa2cf.tar.gz]='https://github.com/mitchellh/vulkan-headers/archive/04c8a0389d5a0236a96312988017cd4ce27d8041.tar.gz'
	[wayland-12202cdac858abc52413a6c6711d5026d2d3c8e13f95ca2c327eade0736298bb021f_20250228.tar.gz]='https://deps.files.ghostty.org/wayland-9cb3d7aa9dc995ffafdbdef7ab86a949d0fb0e7d.tar.gz'
	[wayland_headers-1220b3164434d2ec9db146a40bf3a30f490590d68fa8529776a3138074f0da2c11ca.tar.gz]='https://github.com/mitchellh/wayland-headers/archive/5f991515a29f994d87b908115a2ab0b899474bd1.tar.gz'
	[wayland_protocols-12201a57c6ce0001aa034fa80fba3e1cd2253c560a45748f4f4dd21ff23b491cddef.tar.gz]='https://deps.files.ghostty.org/wayland-protocols-258d8f88f2c8c25a830c6316f87d23ce1a0f12d9.tar.gz'
	[wuffs-122037b39d577ec2db3fd7b2130e7b69ef6cc1807d68607a7c232c958315d381b5cd.tar.gz]='https://github.com/google/wuffs/archive/refs/tags/v0.4.0-alpha.9.tar.gz'
	[x11_headers-122089c326186c84aa2fd034b16abc38f3ebf4862d9ae106dc1847ac44f557b36465.tar.gz]='https://github.com/mitchellh/x11-headers/archive/2ffbd62d82ff73ec929dd8de802bc95effa0ef88.tar.gz'
	[xcode_frameworks-12202adbfecdad671d585c9a5bfcbd5cdf821726779430047742ce1bf94ad67d19cb.tar.gz]='https://github.com/mitchellh/xcode-frameworks/archive/69801c154c39d7ae6129ea1ba8fe1afe00585fc8.tar.gz'
	[z2d-12201f0d542e7541cf492a001d4d0d0155c92f58212fbcb0d224e95edeba06b5416a.tar.gz]='https://github.com/vancluever/z2d/archive/4638bb02a9dc41cc2fb811f092811f6a951c752a.tar.gz'
	[zf-1220edc3b8d8bedbb50555947987e5e8e2f93871ca3c8e8d4cc8f1377c15b5dd35e8.tar.gz]='https://github.com/natecraddock/zf/archive/ed99ca18b02dda052e20ba467e90b623c04690dd.tar.gz'
	[zg-122055beff332830a391e9895c044d33b15ea21063779557024b46169fb1984c6e40.tar.gz]='https://codeberg.org/atman/zg/archive/v0.13.2.tar.gz'
	[zig-objc-1220e17e64ef0ef561b3e4b9f3a96a2494285f2ec31c097721bf8c8677ec4415c634.tar.gz]='https://github.com/mitchellh/zig-objc/archive/9b8ba849b0f58fe207ecd6ab7c147af55b17556e.tar.gz'
	[zig-wayland-12209ca054cb1919fa276e328967f10b253f7537c4136eb48f3332b0f7cf661cad38.tar.gz]='https://deps.files.ghostty.org/zig-wayland-fbfe3b4ac0b472a27b1f1a67405436c58cbee12d.tar.gz'
	[zig_js-12205a66d423259567764fa0fc60c82be35365c21aeb76c5a7dc99698401f4f6fefc.tar.gz]='https://github.com/mitchellh/zig-js/archive/d0b8b0a57c52fbc89f9d9fecba75ca29da7dd7d1.tar.gz'
	[zigimg-1220dd654ef941fc76fd96f9ec6adadf83f69b9887a0d3f4ee5ac0a1a3e11be35cf5.tar.gz]='https://github.com/zigimg/zigimg/archive/3a667bdb3d7f0955a5a51c8468eac83210c1439e.tar.gz'
	[ziglyph-12207831bce7d4abce57b5a98e8f3635811cfefd160bca022eb91fe905d36a02cf25.tar.gz]='https://deps.files.ghostty.org/ziglyph-b89d43d1e3fb01b6074bc1f7fc980324b04d26a5.tar.gz'
	[zlib-1220fed0c74e1019b3ee29edae2051788b080cd96e90d56836eea857b0b966742efb.tar.gz]='https://github.com/madler/zlib/archive/refs/tags/v1.3.1.tar.gz'
)

ZIG_SLOT="0.13"
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
	!<x11-terms/ghostty-1.1.0-r1
	symlink? (
		!>=sys-libs/ncurses-6.5_p20250118[-minimal]
		|| (
			<sys-libs/ncurses-6.5_p20250118
			>=sys-libs/ncurses-6.5_p20250118[minimal]
		)
	)
	!symlink? (
		>=sys-libs/ncurses-6.5_p20250118[-minimal]
	)
"
BDEPEND="sys-libs/ncurses"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-build-add-a-step-for-only-building-terminfo.patch
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
