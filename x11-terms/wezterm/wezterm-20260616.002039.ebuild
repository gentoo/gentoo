# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	unicode_categories@0.1.1
"

RUST_MIN_VER="1.93"

inherit cargo desktop shell-completion xdg-utils

COMMIT="40daec89346f44ca733dbcfa74e144a609d9acba"

DESCRIPTION="A GPU-accelerated cross-platform terminal emulator and multiplexer"
HOMEPAGE="https://wezfurlong.org/wezterm/"

# ebuild name PV from upstream is based on the UTC-2 timestamp of the commit
# TZ=UTC-2 git log -1 --format="%cd" --date=format-local:"%Y%m%d-%H%M%S"
MY_PV="$(ver_rs 1 -)-40daec8"
MY_P="${PN}-${MY_PV}"

SRC_URI="
	https://github.com/wez/${PN}/archive/${COMMIT}.tar.gz -> ${MY_P}-src.tar.gz
	https://dev.gentoo.org/~gienah/snapshots/${PN}-20260610-150805-891bed3-crates.tar.xz
	${CARGO_CRATE_URIS}
"

SUBMODULES=(
	"freetype2 github freetype https://github.com/freetype/freetype 42608f77f20749dd6ddc9e0536788eaad70ea4b5"
	"libpng github freetype https://github.com/glennrp/libpng f5e92d76973a7a53f517579bc95d61483bf108c0"
	"zlib github freetype https://github.com/madler/zlib 51b7f2abdade71cd9bb0e7a373ef2610ec6f9daf"
	"harfbuzz github harfbuzz https://github.com/harfbuzz/harfbuzz 33a3f8de60dcad7535f14f07d6710144548853ac"
	"finl_unicode github . https://github.com/dahosek/finl_unicode 09feefabe28777095de9db2c7b776dc6b6a10475"
	"xcb-imdkit github . https://github.com/wezterm/xcb-imdkit-rs 212330f7c6c37794d78061a773e8f4f9e4785bbb"
)

S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="MIT OFL-1.1"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 BSD-2 BSD CC0-1.0 ISC LGPL-2.1 MIT MPL-2.0 UoI-NCSA
	Unicode-3.0 Unicode-DFS-2016 WTFPL-2 ZLIB
"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="wayland"
RESTRICT=test # tests require network

PATCHES=(
	"${FILESDIR}/${PN}-20260610.150805-finl_unicode.patch"
	"${FILESDIR}/${PN}-20260610.150805-xcb-imdkit.patch"
)

DEPEND="
	dev-libs/libgit2
	dev-libs/openssl
	wayland? ( dev-libs/wayland )
	media-fonts/jetbrains-mono
	media-fonts/noto
	media-fonts/noto-emoji
	media-fonts/roboto
	media-libs/fontconfig
	media-libs/libpng
	media-libs/mesa
	sys-apps/dbus
	x11-libs/cairo[X]
	x11-libs/libX11
	x11-libs/libxkbcommon[X,wayland?]
	x11-libs/xcb-imdkit
	x11-libs/xcb-util
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-wm
	x11-themes/hicolor-icon-theme
	x11-themes/xcursor-themes
	virtual/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-build/cmake
	dev-vcs/git
	virtual/pkgconfig
"

QA_FLAGS_IGNORED="
	usr/bin/.*
"

submodule_uris() {
	for line in "${SUBMODULES[@]}"; do
		read -rd '' name hoster dep url commit < <(printf %s "${line}")

		if [ ${hoster} == "github" ];
		then
			SRC_URI+=" ${url}/archive/${commit}.tar.gz -> ${url##*/}-${commit}.tar.gz"
		elif [ ${hoster} == "gitlab" ];
		then
			SRC_URI+=" ${url}/-/archive/${commit}/${url##*/}-${commit}.tar.gz"
		else
			die
		fi
	done
}

submodule_uris

src_prepare() {
	for line in "${SUBMODULES[@]}"; do
		read -r name hoster dep url commit <<< "${line}" || die

		mkdir -p "${S}/deps/${dep}/${name}" || die
		cp -r "${WORKDIR}"/${url##*/}-${commit}/* "${S}/deps/${dep}/${name}" || die
	done

	pushd "${S}"/deps/finl_unicode || die
	eapply "${FILESDIR}"/finl_unicode-1.3.0-no_std.patch
	popd || die

	echo "${MY_PV}-gentoo" > .tag || die

	default
}

src_configure() {
	local myfeatures=(
		distro-defaults
		vendor-nerd-font-symbols-font
		$(usev wayland)
	)
	cargo_src_configure --no-default-features
}

src_compile() {
	cargo_src_compile
}

src_install() {
	exeinto /usr/bin
	doexe "$(cargo_target_dir)/wezterm"
	doexe "$(cargo_target_dir)/wezterm-gui"
	doexe "$(cargo_target_dir)/wezterm-mux-server"
	doexe "$(cargo_target_dir)/strip-ansi-escapes"

	insinto /usr/share/icons/hicolor/128x128/apps
	newins assets/icon/terminal.png org.wezfurlong.wezterm.png

	newmenu assets/wezterm.desktop org.wezfurlong.wezterm.desktop

	insinto /usr/share/metainfo
	newins assets/wezterm.appdata.xml org.wezfurlong.wezterm.appdata.xml

	newbashcomp assets/shell-completion/bash ${PN}
	newzshcomp assets/shell-completion/zsh _${PN}
	newfishcomp assets/shell-completion/fish ${PN}.fish
}

pkg_postinst() {
	xdg_icon_cache_update
	einfo "It may be necessary to configure wezterm to use a cursor theme, see:"
	einfo "https://wezfurlong.org/wezterm/faq.html?highlight=xcursor_theme#i-use-x11-or-wayland-and-my-mouse-cursor-theme-doesnt-seem-to-work"
	einfo "It may be necessary to set the environment variable XCURSOR_PATH"
	einfo "to the directory containing the cursor icons, for example"
	einfo 'export XCURSOR_PATH="/usr/share/cursors/xorg-x11/"'
	einfo "before starting the wayland or X11 window compositor to avoid the error:"
	einfo "ERROR  window::os::wayland::frame > Unable to set cursor to left_ptr: cursor not found"
	einfo "For example, in the file ~/.wezterm.lua:"
	einfo "return {"
	einfo '  xcursor_theme = "whiteglass"'
	einfo "}"
}

pkg_postrm() {
	xdg_icon_cache_update
}
