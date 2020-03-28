# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit multilib-minimal check-reqs

#cmake-multilib and cmake-utils build doesn't support https://github.com/GPUOpen-Drivers/AMDVLK/issues/151
DESCRIPTION="AMD Open Source Driver for Vulkan"
HOMEPAGE="https://github.com/GPUOpen-Drivers/AMDVLK"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug wayland"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )"
###DEPENDS
BUNDLED_LLVM_DEPEND="sys-libs/zlib:0=[${MULTILIB_USEDEP}]"
DEPEND="wayland? ( dev-libs/wayland[${MULTILIB_USEDEP}] )
	${BUNDLED_LLVM_DEPEND}
	>=dev-util/vulkan-headers-1.2.133"
BDEPEND="${BUNDLED_LLVM_DEPEND}
	dev-util/cmake"
RDEPEND=" ${DEPEND}
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence[${MULTILIB_USEDEP}]
	virtual/libstdc++
	>=media-libs/vulkan-loader-1.2.133[${MULTILIB_USEDEP}]"

CHECKREQS_MEMORY="4G"
CHECKREQS_DISK_BUILD="2G"
S="${WORKDIR}"
CMAKE_USE_DIR="${S}/xgl"

###SOURCE CODE VARIABLES
FETCH_URI="https://github.com/GPUOpen-Drivers"
CORRECT_AMDVLK_PV="v-$(ver_rs 1 '.Q')" #Works only for amdvlk source code: transforming version 2019.2.2 to v-2019.Q2.2. Any other commits should be updated manually
##For those who wants update ebuild: check https://github.com/GPUOpen-Drivers/AMDVLK/blob/master/default.xml
##and place commits in the desired variables
## EXAMPLE: XGL_COMMIT="80e5a4b11ad2058097e77746772ddc9ab2118e07"
## SRC_URI="... ${FETCH_URI}/$PART/archive/$COMMIT.zip -> $PART-$COMMIT.zip ..."
XGL_COMMIT="2db4177e78133c868e2c6b4dcc46aeb2f512163a"
PAL_COMMIT="bb7398b1c7509a30ba4f7d947b5ad5549a4d58db"
LLPC_COMMIT="7686a2ddba683f7a361460f3806b0d45e615ca76"
SPVGEN_COMMIT="d16fddddf22a1eb3a3f4ce05cbcb95a337f708b1"
LLVM_PROJECT_COMMIT="5c958c70bc6366298296dc778e903f65528c3b0f"
METROHASH_COMMIT="2b6fee002db6cc92345b02aeee963ebaaf4c0e2f"
CWPACK_COMMIT="b601c88aeca7a7b08becb3d32709de383c8ee428"
## SRC_URI
SRC_URI=" ${FETCH_URI}/AMDVLK/archive/${CORRECT_AMDVLK_PV}.tar.gz -> AMDVLK-${CORRECT_AMDVLK_PV}.tar.gz
${FETCH_URI}/xgl/archive/${XGL_COMMIT}.tar.gz -> xgl-${XGL_COMMIT}.tar.gz
${FETCH_URI}/pal/archive/${PAL_COMMIT}.tar.gz -> pal-${PAL_COMMIT}.tar.gz
${FETCH_URI}/llpc/archive/${LLPC_COMMIT}.tar.gz -> llpc-${LLPC_COMMIT}.tar.gz
${FETCH_URI}/spvgen/archive/${SPVGEN_COMMIT}.tar.gz -> spvgen-${SPVGEN_COMMIT}.tar.gz
${FETCH_URI}/llvm-project/archive/${LLVM_PROJECT_COMMIT}.tar.gz -> llvm-project-${LLVM_PROJECT_COMMIT}.tar.gz
${FETCH_URI}/MetroHash/archive/${METROHASH_COMMIT}.tar.gz -> MetroHash-${METROHASH_COMMIT}.tar.gz
${FETCH_URI}/CWPack/archive/${CWPACK_COMMIT}.tar.gz -> CWPack-${CWPACK_COMMIT}.tar.gz"

###EBUILD FUNCTIONS
src_prepare() {
	##moving src to proper directories
	mkdir -p ${S}
	mkdir -p ${S}/third_party
	mv AMDVLK-${CORRECT_AMDVLK_PV}/ ${S}/AMDVLK
	mv xgl-${XGL_COMMIT}/ ${S}/xgl
	mv pal-${PAL_COMMIT}/ ${S}/pal
	mv llpc-${LLPC_COMMIT}/ ${S}/llpc
	mv spvgen-${SPVGEN_COMMIT}/ ${S}/spvgen
	mv llvm-project-${LLVM_PROJECT_COMMIT}/ ${S}/llvm-project
	mv MetroHash-${METROHASH_COMMIT}/ ${S}/third_party/metrohash
	mv CWPack-${CWPACK_COMMIT}/ ${S}/third_party/cwpack
	##Installing rule
	cat << EOF > "${T}/10-amdvlk-dri3.conf" || die
Section "Device"
Identifier "AMDgpu"
Option  "DRI" "3"
EndSection
EOF
	cd ${S}/xgl
	default
}

multilib_src_configure() {
	local mycmakeargs=( \
			-DBUILD_WAYLAND_SUPPORT=$(usex wayland ) \
			-DCMAKE_BUILD_TYPE="$(usex debug "Debug" "Release")" \
			-B${BUILD_DIR} )
	cd ${S}/xgl
	cmake -H. "${mycmakeargs[@]}"
}

multilib_src_install() {
	if use abi_x86_64 && multilib_is_native_abi; then
		mkdir -p ${D}/usr/lib64/
		mv "${BUILD_DIR}/icd/amdvlk64.so" ${D}/usr/lib64/
		insinto /usr/share/vulkan/icd.d
		doins ${S}/AMDVLK/json/Redhat/amd_icd64.json
	else
		mkdir -p ${D}/usr/lib/
		mv "${BUILD_DIR}/icd/amdvlk32.so" ${D}/usr/lib/
		insinto /usr/share/vulkan/icd.d
		doins ${S}/AMDVLK/json/Redhat/amd_icd32.json
	fi
}

multilib_src_install_all() {
	insinto /usr/share/X11/xorg.conf.d/
	doins ${T}/10-amdvlk-dri3.conf
	einfo "AMDVLK requires DRI3 mode so config file is istalled in /usr/share/X11/xorg.conf.d/10-amdvlk-dri3.conf"
	einfo "It's safe to double xorg configuration files if you have already had ones"
}

pkg_postinst() {
	elog "More information about the configuration can be found here:"
	elog " https://github.com/GPUOpen-Drivers/AMDVLK"
	ewarn "Make sure the following line is NOT included in the any Xorg configuration section:"
	ewarn "Driver      \"modesetting\""
	ewarn "Else AMDVLK breaks things"
	ewarn "With some games AMDVLK is still not stable. Use it at you own risk"
	elog "You may want to disable default vulkan mesa provider in package.use \"media-libs/mesa -vulkan\""
	elog "or perform export in /etc/env.d/ variable VK_ICD_FILENAMES=vulkanprovidername:vulkanprovidername2 "
	elog "exampe| VK_ICD_FILENAMES=\"/usr/share/vulkan/icd.d/amd_icd64.json:/usr/share/vulkan/icd.d/amd_icd64.json\""
}
