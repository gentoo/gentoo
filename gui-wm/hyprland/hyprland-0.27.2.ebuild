# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${PF}.gh.tar.gz"
S="${WORKDIR}/${PN}-source"

KEYWORDS="~amd64"
LICENSE="BSD"
SLOT="0"
IUSE="X legacy-renderer systemd video_cards_nvidia"

RDEPEND="
	app-misc/jq
	dev-libs/glib:2
	dev-libs/libinput:=
	dev-libs/libliftoff
	dev-libs/wayland
	dev-libs/wayland-protocols
	dev-util/glslang
	dev-util/vulkan-headers
	gui-libs/gtk-layer-shell
	media-libs/libdisplay-info
	media-libs/libglvnd[X?]
	media-libs/mesa[gles2,wayland,X?]
	media-libs/vulkan-loader
	sys-auth/seatd:=
	x11-base/xcb-proto
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	x11-misc/xkeyboard-config
	virtual/libudev:=
	X? (
	   gui-libs/wlroots[x11-backend]
	   x11-base/xwayland
	   x11-libs/libxcb:=
	   x11-libs/xcb-util-image
	   x11-libs/xcb-util-renderutil
	   x11-libs/xcb-util-wm
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/hyprland-protocols
	>=dev-libs/wayland-1.22.0
	dev-util/wayland-scanner
	dev-vcs/git
	>=gui-libs/wlroots-0.16.0[X?]
"

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if tc-is-gcc; then
		STDLIBVER=$(echo '#include <string>' | $(tc-getCXX) -x c++ -dM -E - | \
					grep GLIBCXX_RELEASE | sed 's/.*\([1-9][0-9]\)/\1/')

		if ! [[ ${STDLIBVER} -ge 12 ]]; then
			die "Hyprland requires >=sys-devel/gcc-12.1.0 to build"
		fi
	elif [[ $(clang-major-version) -lt 16 ]]; then
		die "Hyprland requires >=sys-devel/clang-16.0.3 to build";
	fi
}

src_prepare() {
	if use video_cards_nvidia; then
		cd "${S}/subprojects/wlroots" || die
		eapply "${FILESDIR}/nvidia-0.25.0.patch"
		cd "${S}" || die
	fi

	default
}

src_configure() {
	local emesonargs=(
		$(meson_feature legacy-renderer legacy_renderer)
		$(meson_feature X xwayland)
		$(meson_feature systemd)
	)

	meson_src_configure
}

src_install() {
	meson_src_install --skip-subprojects wlroots
}
