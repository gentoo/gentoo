# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} )

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/KhronosGroup/Vulkan-Loader.git"
	EGIT_SUBMODULES=()
	inherit git-r3
else
	if [[ -z ${SNAPSHOT_COMMIT} ]]; then
		MY_PV=v${PV}
		MY_P=Vulkan-Loader-${PV}
	else
		MY_PV=${SNAPSHOT_COMMIT}
		MY_P=Vulkan-Loader-${SNAPSHOT_COMMIT}
	fi
	KEYWORDS="amd64 ~x86"
	SRC_URI="https://github.com/KhronosGroup/Vulkan-Loader/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}"/${MY_P}
fi

inherit toolchain-funcs python-any-r1 cmake-multilib

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Loader"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="layers wayland X"

PDEPEND="layers? ( media-libs/vulkan-layers:=[${MULTILIB_USEDEP}] )"
DEPEND="${PYTHON_DEPS}
	>=dev-util/vulkan-headers-${PV}
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)"

multilib_src_configure() {
	# Integrated clang assembler doesn't work with x86 - Bug #698164
	if tc-is-clang && [[ ${ABI} == x86 ]]; then
		append-cflags -fno-integrated-as
	fi

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=True
		-DBUILD_TESTS=False
		-DBUILD_LOADER=True
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_HEADERS_INSTALL_DIR="/usr"
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	cmake-utils_src_install
}

pkg_postinst() {
	einfo "USE=demos has been dropped as per upstream packaging"
	einfo "vulkaninfo is now available in the dev-util/vulkan-tools package"
}
