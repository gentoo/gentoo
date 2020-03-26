# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit cmake-multilib check-reqs

DESCRIPTION="AMD Open Source Driver for Vulkan"
HOMEPAGE="https://github.com/GPUOpen-Drivers/AMDVLK"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="debug wayland"
REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )"
###DEPENDS
BUNDLED_LLVM_DEPEND="sys-libs/zlib:0=[${MULTILIB_USEDEP}]"
DEPEND="	wayland? (	 dev-libs/wayland[${MULTILIB_USEDEP}] 	)
	${BUNDLED_LLVM_DEPEND}
	"
BDEPEND="${DEPEND}
dev-util/cmake"
RDEPEND=" ${DEPEND}
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence[${MULTILIB_USEDEP}]
	virtual/libstdc++
	>=media-libs/vulkan-loader-1.2.133[${MULTILIB_USEDEP}]
	"

CHECKREQS_MEMORY="4G"
CHECKREQS_DISK_BUILD="2G"
S="${WORKDIR}"
CMAKE_USE_DIR="${S}/xgl"

###SOURCE CODE VARIABLES
FETCH_URI="https://github.com/GPUOpen-Drivers"
CORRECT_AMDVLK_PV="v-$(ver_rs 1 '.Q')" #Only for amdvlk source code: transforming version 2019.2.2 to v-2019.Q2.2. Any other commits should be updated manually
##For those who wants update ebuild: check https://github.com/GPUOpen-Drivers/AMDVLK/blob/master/default.xml
##and place commits in the desired variables
## EXAMPLE: XGL_COMMIT="80e5a4b11ad2058097e77746772ddc9ab2118e07"
## SRC_URI="... ${FETCH_URI}/$PART/archive/$COMMIT.zip -> $PART-$COMMIT.zip ..."
PATCHES=( ${FILESDIR}/amdvlk-cmake-dso.patch ) #remove after mainlining changes
XGL_COMMIT="80e5a4b11ad2058097e77746772ddc9ab2118e07"
PAL_COMMIT="e642f608a62887d40d1f25509d2951a4a3576985"
LLPC_COMMIT="fc21c950b629753f9cc7d0941937c57262ceadcf"
SPVGEN_COMMIT="843c6b95f731589bf497fad29dadf7fda4934aad"
LLVM_PROJECT_COMMIT="e404e4b2db325184dbc2d14f31ef891d938f3835"
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
mkdir -p ${S}; mkdir -p ${S}/third_party
mv AMDVLK-${CORRECT_AMDVLK_PV}/ ${S}/AMDVLK
mv xgl-${XGL_COMMIT}/ ${S}/xgl
mv pal-${PAL_COMMIT}/ ${S}/pal
mv llpc-${LLPC_COMMIT}/ ${S}/llpc
mv spvgen-${SPVGEN_COMMIT}/ ${S}/spvgen
mv llvm-project-${LLVM_PROJECT_COMMIT}/ ${S}/llvm-project
mv MetroHash-${METROHASH_COMMIT}/ ${S}/third_party/metrohash
mv CWPack-${CWPACK_COMMIT}/ ${S}/third_party/cwpack
cat << EOF > "${T}/10-amdvlk-dri3.conf" || die
Section "Device"
Identifier "AMDgpu"
Option  "DRI" "3"
EndSection
EOF

cmake-utils_src_prepare
}

multilib_src_configure() {
CMAKE_BUILD_TYPE="$(usex debug "Debug" "Release")"
	local mycmakeargs=(	-DBUILD_WAYLAND_SUPPORT=$(usex wayland )	)
cmake-utils_src_configure
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
einfo "json files installs to /usr/share/vulkan/icd.d instead of /etc because it shouldn't honor config-protect"
cmake-utils_src_install
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
	ewarn "Make sure the following line is NOT included in the any Xorg configuration section: "
	ewarn "Driver      \"modesetting\""
	ewarn "Else AMDVLK breaks things"
}
