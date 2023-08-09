# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${PN}-source"

KEYWORDS="~amd64"
LICENSE="BSD"
SLOT="0"
IUSE="X legacy-renderer systemd video_cards_nvidia"

# bundled wlroots has the following dependency string according to included headers.
# wlroots[drm,gles2-renderer,libinput,x11-backend?,X?]
# enable x11-backend with X and vice versa
WLROOTS_RDEPEND="
	>=dev-libs/libinput-1.14.0:=
	dev-libs/libliftoff
	>=dev-libs/wayland-1.22
	media-libs/libdisplay-info
	media-libs/libglvnd
	media-libs/mesa[egl(+),gles2]
	sys-apps/hwdata:=
	sys-auth/seatd:=
	>=x11-libs/libdrm-2.4.114
	x11-libs/libxkbcommon
	>=x11-libs/pixman-0.42.0
	virtual/libudev:=
	X? (
		x11-base/xwayland
		x11-libs/libxcb:0=
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
	)
"
WLROOTS_DEPEND="
	>=dev-libs/wayland-protocols-1.32
"
WLROOTS_BDEPEND="
	dev-util/glslang
	dev-util/wayland-scanner
"

RDEPEND="
	${WLROOTS_RDEPEND}
	dev-libs/glib:2
	dev-libs/libinput
	dev-libs/wayland
	media-libs/libglvnd
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
	X? (
		x11-libs/libxcb:0=
	)
"
DEPEND="
	${RDEPEND}
	${WLROOTS_DEPEND}
	dev-libs/hyprland-protocols
	>=dev-libs/wayland-protocols-1.25
"
BDEPEND="
	${WLROOTS_BDEPEND}
	app-misc/jq
	dev-util/cmake
	dev-util/wayland-scanner
	dev-vcs/git
	virtual/pkgconfig
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
		eapply "${S}/nix/patches/wlroots-nvidia.patch"
		# https://bugs.gentoo.org/911597
		# https://github.com/hyprwm/Hyprland/pull/2874
		# https://github.com/hyprwm/Hyprland/blob/main/nix/wlroots.nix#L54
		sed -i -e 's/glFlush();/glFinish();/' render/gles2/renderer.c || die
		cd "${S}" || die
	fi

	eapply "${FILESDIR}/hyprland-0.28.0-no-wlroots-automagic-r1.patch"

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
