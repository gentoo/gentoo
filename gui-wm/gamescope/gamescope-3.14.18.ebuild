# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps meson

RESHADE_COMMIT="9fdbea6892f9959fdc18095d035976c574b268b7"
WLROOTS_COMMIT="a5c9826e6d7d8b504b07d1c02425e6f62b020791"
MY_PV=$(ver_rs 3 -)
MY_PV="${MY_PV//_/-}"

DESCRIPTION="Efficient micro-compositor for running games"
HOMEPAGE="https://github.com/ValveSoftware/gamescope"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/ValveSoftware/${PN}.git"
	# Prevent wlroots and other submodule from being pull
	# Not messing with system packages
	EGIT_SUBMODULES=( src/reshade )
	inherit git-r3
else
	SRC_URI="
		https://github.com/ValveSoftware/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
		https://github.com/Joshua-Ashton/reshade/archive/${RESHADE_COMMIT}.tar.gz -> reshade-${RESHADE_COMMIT}.tar.gz
		https://github.com/Joshua-Ashton/wlroots/archive/${WLROOTS_COMMIT}.tar.gz -> wlroots-${WLROOTS_COMMIT}.tar.gz
	"
	KEYWORDS="~amd64"
fi

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD-2"
SLOT="0"
IUSE="pipewire +wsi-layer"

# For when wlroots 0.18 is released.
# =gui-libs/wlroots-0.18*[X,libinput(+)]

RDEPEND="
	>=dev-libs/wayland-1.21
	gui-libs/libdecor
	>=media-libs/libavif-1.0.0:=
	>=media-libs/libdisplay-info-0.1.1
	media-libs/libsdl2[video,vulkan]
	media-libs/vulkan-loader
	sys-apps/hwdata
	sys-libs/libcap
	>=x11-libs/libdrm-2.4.109
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libxkbcommon
	x11-libs/libXmu
	x11-libs/libXrender
	x11-libs/libXres
	x11-libs/libXtst
	x11-libs/libXxf86vm
	pipewire? ( >=media-video/pipewire-0.3:= )
	wsi-layer? ( x11-libs/libxcb )

	>=dev-libs/libinput-1.14.0:=
	media-libs/libglvnd
	media-libs/mesa[egl(+),gles2(+)]
	sys-auth/seatd:=
	virtual/libudev
	x11-base/xwayland
	x11-libs/libxcb:=
	>=x11-libs/pixman-0.42.0
	x11-libs/xcb-util-wm
"
DEPEND="
	${RDEPEND}
	=dev-libs/libliftoff-0.5*
	>=dev-libs/wayland-protocols-1.34
	>=dev-libs/stb-20240201-r1
	dev-util/vulkan-headers
	media-libs/glm
	dev-util/spirv-headers
	wsi-layer? ( >=media-libs/vkroots-0_p20240430 )
"
RDEPEND+="
	dev-libs/libliftoff
"
BDEPEND="
	dev-util/glslang
	dev-util/wayland-scanner
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-deprecated-stb.patch
)

FILECAPS=(
	cap_sys_nice usr/bin/${PN}
)

src_prepare() {
	default

	# ReShade is bundled as a git submodule, but it references an unofficial
	# fork, so we cannot unbundle it. Symlink to its extracted sources.
	# For 9999, use the bundled submodule.
	if [[ ${PV} != "9999" ]]; then
		rmdir src/reshade || die
		ln -snfT ../../reshade-${RESHADE_COMMIT} src/reshade || die
	fi

	# SPIRV-Headers is required by ReShade. It is bundled as a git submodule but
	# not wrapped with Meson, so we can symlink to our system-wide headers.
	# For 9999, this submodule is not included.
	mkdir -p thirdparty/SPIRV-Headers/include || die
	ln -snf "${ESYSROOT}"/usr/include/spirv thirdparty/SPIRV-Headers/include/ || die

	# Until wlroots 0.18 is released.
	rmdir subprojects/wlroots || die
	ln -snfT ../../wlroots-${WLROOTS_COMMIT} subprojects/wlroots || die
}

src_configure() {
	local emesonargs=(
		--force-fallback-for=
		-Dbenchmark=disabled
		-Denable_openvr_support=false
		$(meson_feature pipewire)
		$(meson_use wsi-layer enable_gamescope_wsi_layer)

		-Dwlroots:xcb-errors=disabled
		-Dwlroots:examples=false
		-Dwlroots:renderers=gles2,vulkan
		-Dwlroots:xwayland=enabled
		-Dwlroots:backends=libinput
		-Dwlroots:session=enabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install --skip-subprojects
}
