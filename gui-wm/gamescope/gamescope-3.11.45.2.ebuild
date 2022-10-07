# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit fcaps meson

MY_PV=$(ver_rs 3 -)
MY_PV="${MY_PV//_/-}"
DESCRIPTION="Efficient micro-compositor for running games"
HOMEPAGE="https://github.com/Plagman/gamescope"
SRC_URI="https://github.com/Plagman/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
LICENSE="BSD-2"
SLOT="0"
IUSE="pipewire"

RDEPEND="
	=dev-libs/libliftoff-0.3*
	>=dev-libs/wayland-1.21
	>=dev-libs/wayland-protocols-1.17
	=gui-libs/wlroots-0.15*[X]
	media-libs/libsdl2[video]
	media-libs/vulkan-loader
	sys-libs/libcap
	>=x11-libs/libdrm-2.4.109
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXrender
	x11-libs/libXres
	x11-libs/libXtst
	x11-libs/libXxf86vm
	pipewire? ( >=media-video/pipewire-0.3:= )
"
DEPEND="
	${RDEPEND}
	dev-libs/stb
	dev-util/vulkan-headers
"
BDEPEND="
	dev-util/glslang
	dev-util/wayland-scanner
"

S="${WORKDIR}/${PN}-${MY_PV}"

FILECAPS=(
	cap_sys_nice usr/bin/${PN}
)

src_prepare() {
	default

	# Normally uses stb from a git submodule. Upstream does not ship a
	# pkg-config file so we don't install one. Work around this using symlinks.
	mkdir subprojects/stb || die
	ln -snf "${ESYSROOT}"/usr/include/stb/* "${S}"/subprojects/packagefiles/stb/* subprojects/stb/ || die
}

src_configure() {
	local emesonargs=(
		--force-fallback-for=
		$(meson_feature pipewire)
	)
	meson_src_configure
}
