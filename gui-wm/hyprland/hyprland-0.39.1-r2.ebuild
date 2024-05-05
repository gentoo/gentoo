# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson toolchain-funcs

DESCRIPTION="A dynamic tiling Wayland compositor that doesn't sacrifice on its looks"
HOMEPAGE="https://github.com/hyprwm/Hyprland"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hyprwm/${PN^}.git"
else
	SRC_URI="https://github.com/hyprwm/${PN^}/releases/download/v${PV}/source-v${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-source"

	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="BSD"
SLOT="0"
IUSE="X legacy-renderer systemd"

# hyprpm (hyprland plugin manager) requires the dependencies at runtime
# so that it can clone, compile and install plugins.
HYPRPM_RDEPEND="
	app-alternatives/ninja
	dev-build/cmake
	dev-build/meson
	dev-libs/libliftoff
	dev-vcs/git
	virtual/pkgconfig
"
# bundled wlroots has the following dependency string according to included headers.
# wlroots[drm,gles2-renderer,libinput,x11-backend?,X?]
# enable x11-backend with X and vice versa
WLROOTS_DEPEND="
	>=dev-libs/wayland-1.22
	media-libs/libglvnd
	media-libs/mesa[egl(+),gles2]
	>=x11-libs/libdrm-2.4.114
	x11-libs/libxkbcommon
	>=x11-libs/pixman-0.42.0
	media-libs/libdisplay-info
	sys-apps/hwdata
	>=dev-libs/libinput-1.14.0:=
	sys-auth/seatd:=
	virtual/libudev:=
	X? (
		x11-libs/libxcb:=
		x11-libs/xcb-util-renderutil
		x11-libs/xcb-util-wm
		x11-base/xwayland
	)
"
WLROOTS_RDEPEND="
	${WLROOTS_DEPEND}
"
WLROOTS_BDEPEND="
	>=dev-libs/wayland-protocols-1.32
	dev-util/wayland-scanner
	virtual/pkgconfig
"
RDEPEND="
	${HYPRPM_RDEPEND}
	${WLROOTS_RDEPEND}
	dev-cpp/tomlplusplus
	dev-libs/glib:2
	dev-libs/libinput
	>=dev-libs/wayland-1.20.0
	>=gui-libs/hyprcursor-0.1.7
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
	>=dev-libs/hyprland-protocols-0.2
	>=dev-libs/hyprlang-0.3.2
	>=dev-libs/wayland-protocols-1.32
"
BDEPEND="
	${WLROOTS_BDEPEND}
	|| ( >=sys-devel/gcc-13:* >=sys-devel/clang-16:* )
	app-misc/jq
	dev-build/cmake
	dev-util/wayland-scanner
	virtual/pkgconfig
"

PATCHES=(
	# https://bugs.gentoo.org/930132
	# https://github.com/hyprwm/Hyprland/pull/5653
	"${FILESDIR}/bash-completion-fix-0.39.1.patch"
)

pkg_setup() {
	[[ ${MERGE_TYPE} == binary ]] && return

	if tc-is-gcc && ver_test $(gcc-version) -lt 13 ; then
		eerror "Hyprland requires >=sys-devel/gcc-13 to build"
		eerror "Please upgrade GCC: emerge -v1 sys-devel/gcc"
		die "GCC version is too old to compile Hyprland!"
	elif tc-is-clang && ver_test $(clang-version) -lt 16 ; then
		eerror "Hyprland requires >=sys-devel/clang-16 to build"
		eerror "Please upgrade Clang: emerge -v1 sys-devel/clang"
		die "Clang version is too old to compile Hyprland!"
	fi
}

src_configure() {
	local emesonargs=(
		$(meson_feature legacy-renderer legacy_renderer)
		$(meson_feature systemd)
		$(meson_feature X xwayland)
		$(meson_feature X wlroots:xwayland)
		-Dwlroots:backends=drm,libinput$(usev X ',x11')
		-Dwlroots:xcb-errors=disabled
	)

	meson_src_configure
}

src_install() {
	# First install everything except wlroots to avoid conflicts.
	meson_src_install --skip-subprojects wlroots
	# Then install development files (mainly wlroots) for bug #916760.
	meson_src_install --tags devel

	# Wlroots headers are required by hyprland-plugins and the pkgconfig file expects
	# them to be in /usr/include/hyprland/wlroots, despite this they aren't installed there.
	# Ideally you could override includedir per subproject and the install tags would
	# be granular enough to only install headers. But its not requiring this.
	mkdir "${ED}"/usr/include/hyprland/wlroots || die
	mv "${ED}"/usr/include/wlr "${ED}"/usr/include/hyprland/wlroots || die
	# devel tag includes wlroots .pc and .a files still
	rm -rf "${ED}"/usr/$(get_libdir)/ || die
}
