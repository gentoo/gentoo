# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="OBS Linux Vulkan/OpenGL game capture"
HOMEPAGE="https://github.com/nowrep/obs-vkcapture"

if [[ ${PV} == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/nowrep/obs-vkcapture.git"
else
	SRC_URI="https://github.com/nowrep/obs-vkcapture/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="X wayland"

REQUIRED_USE="|| ( X wayland )"

COMMON_DEPENDS="
	>=media-video/obs-studio-30.2.0
	>=media-libs/libglvnd-1.7.0[X=,${MULTILIB_USEDEP}]
	X? (
		x11-libs/libxcb:=[${MULTILIB_USEDEP}]
	)
	wayland? (
		>=dev-libs/wayland-1.22.0
	)
"
DEPEND="${COMMON_DEPENDS}
	>=media-libs/vulkan-loader-1.3[X=,layers,wayland=,${MULTILIB_USEDEP}]
	dev-util/vulkan-headers
	wayland? (
		>=dev-util/wayland-scanner-1.22.0
	)
	X? (
		x11-libs/libX11
	)
"
RDEPEND="${COMMON_DEPENDS}"

QA_SONAME="
	/usr/lib/libVkLayer_obs_vkcapture.so
	/usr/lib64/libVkLayer_obs_vkcapture.so
"

pkg_postinst() {
	if [[ $(</sys/module/nvidia_drm/parameters/modeset) != Y ]] 2>/dev/null; then
		elog "This plugin needs nvidia-drm with modeset configured properly"
		elog "to capture windows. To enable, edit /etc/modprobe.d/nvidia.conf"
		elog "and uncomment the nvidia-drm options to enable modeset."
		elog
	fi

	elog "This plugin can only capture the game window if you add one of the"
	elog "following launcher options to the game (Steam as an example):"
	elog "  - OBS_VKCAPTURE=1 %command% (recommended, Vulkan)"
	elog "  - obs-gamecapture %command% (generic, OpenGL and Vulkan)"
	elog
	elog "HINT: This may currently not work on wayland with"
	elog "x11-drivers/nvidia-drivers[kernel-open]"
}

multilib_src_configure() {
	if ! multilib_is_native_abi; then
		local mycmakeargs+=(
			-DBUILD_PLUGIN=OFF
		)
	fi
	cmake_src_configure
}
