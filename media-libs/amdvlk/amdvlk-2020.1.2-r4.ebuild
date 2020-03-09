# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit python-r1 git-r3 multilib-minimal check-reqs
DESCRIPTION="AMD Open Source Driver for Vulkan"
HOMEPAGE="https://github.com/GPUOpen-Drivers/AMDVLK"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="debug wayland"
REQUIRED_USE=" $PYTHON_REQUIRED_USE"
DEPEND="dev-util/cmake
${PYTHON_DEPS}
wayland? (	dev-libs/wayland[${MULTILIB_USEDEP}]	)
>=dev-util/vulkan-headers-1.2.133"
RDEPEND="${PYTHON_DEPS}
x11-libs/libdrm[${MULTILIB_USEDEP}]
x11-libs/libXrandr[${MULTILIB_USEDEP}]
x11-libs/libxcb[${MULTILIB_USEDEP}]
x11-libs/libxshmfence[${MULTILIB_USEDEP}]
virtual/libstdc++
>=dev-util/vulkan-headers-1.2.133
>=media-libs/vulkan-loader-1.2.133[${MULTILIB_USEDEP}]
net-misc/curl
wayland? (	dev-libs/wayland[${MULTILIB_USEDEP}]	)"
CHECKREQS_MEMORY="3G"
CHECKREQS_DISK_BUILD="2G"
###AMDVLK BASE
FETCH_URI="https://github.com/GPUOpen-Drivers"
EGIT_REPO_URI="$FETCH_URI/AMDVLK"
EGIT_COMMIT="b81c3a09c91bb49e287ea163a7527ed914638eb8"
EGIT_CHECKOUT_DIR="${S}/drivers/AMDVLK"
###FUNCTIONS
src_unpack() {
mkdir -p ${S}/drivers
cd ${S}/drivers
#for those who wants update ebuild: check https://github.com/GPUOpen-Drivers/AMDVLK/blob/master/default.xml
#and place it in the constructions
#Fetching: git-r3_fetch «repo» «commit»
#Then placing it: git-r3_checkout «repo» «part»
#Currently it's impossible to fetch full amdvlk code without getting LIVEVCS.unmasked error from `repoman full`
#Repo is not choise because it's raw: can't fetch desired commits yet and deletes fetched files.
PART="xgl"
COMMIT_ID="8024f27f9457e3235bf4fcde0d2879bbaae7b0f2"
git-r3_fetch "${FETCH_URI}/${PART}" "${COMMIT_ID}"
git-r3_checkout "${FETCH_URI}/${PART}" ${S}/drivers/$PART
#pal
PART="pal"
COMMIT_ID="45f531beaf2c2b0bc2272e63a2da0022f1b07ccf"
git-r3_fetch "${FETCH_URI}/${PART}" ${COMMIT_ID}
git-r3_checkout "${FETCH_URI}/${PART}" ${S}/drivers/$PART
#llpc
PART="llpc"
COMMIT_ID="f5268c3f6f906a3ae430a1aada7f54f70df091e8"
git-r3_fetch "${FETCH_URI}/${PART}" ${COMMIT_ID}
git-r3_checkout "${FETCH_URI}/${PART}" ${S}/drivers/$PART
#spvgen
PART="spvgen"
COMMIT_ID="e9b2bc3a889ed6ac4f5a47b6c4c58460988e352e"
git-r3_fetch "${FETCH_URI}/${PART}" ${COMMIT_ID}
git-r3_checkout "${FETCH_URI}/${PART}" ${S}/drivers/$PART
#AMDVLK - moved to upper in egit_repo_uri
git-r3_fetch $EGIT_REPO_URI $EGIT_COMMIT
git-r3_checkout $EGIT_REPO_URI $EGIT_CHECKOUT_DIR
#
#LLVM. At this moment we had to download appropriate source code to build amdvlk.
PART="llvm-project"
COMMIT_ID="a163b38723cbc05f3014d4eaa1936c82bbfbf3ea"
git-r3_fetch "${FETCH_URI}/${PART}" ${COMMIT_ID}
git-r3_checkout "${FETCH_URI}/${PART}" ${S}/drivers/$PART
PART="MetroHash"
COMMIT_ID="2b6fee002db6cc92345b02aeee963ebaaf4c0e2f"
git-r3_fetch "${FETCH_URI}/${PART}" ${COMMIT_ID}
git-r3_checkout "${FETCH_URI}/${PART}" ${S}/drivers/third_party/metrohash
PART="CWPack"
COMMIT_ID="b601c88aeca7a7b08becb3d32709de383c8ee428"
git-r3_fetch "${FETCH_URI}/${PART}" ${COMMIT_ID}
git-r3_checkout "${FETCH_URI}/${PART}" ${S}/drivers/third_party/cwpack
}
src_prepare() {
	cat << EOF > "${T}/10-amdvlk-dri3.conf" || die
Section "Device"
Identifier "AMDgpu"
Option  "DRI" "3"
EndSection
EOF
	default
}
multilib_src_configure() {
	local myconf=()
	cd "${S}/drivers/xgl"
	myconf+=( -B${BUILD_DIR} )
	if use debug; then
		myconf+=( -DCMAKE_BUILD_TYPE=Debug )
	fi
	cmake -H. "${myconf[@]}"
	if use wayland; then
		myconf+=( -DBUILD_WAYLAND_SUPPORT=ON )
	fi
}
multilib_src_install() {
	if use abi_x86_64 && multilib_is_native_abi; then
		mkdir -p $D/usr/lib64/
		mv "${BUILD_DIR}/icd/amdvlk64.so" $D/usr/lib64/
		insinto /usr/share/vulkan/icd.d
		doins ${S}/drivers/AMDVLK/json/Redhat/amd_icd64.json
	else
		mkdir -p $D/usr/lib/
		mv "${BUILD_DIR}/icd/amdvlk32.so" $D/usr/lib/
		insinto /usr/share/vulkan/icd.d
		doins ${S}/drivers/AMDVLK/json/Redhat/amd_icd32.json
	fi
	einfo "json files installs to /usr/share/vulkan/icd.d instead of /etc because it shouldn't honor config-protect"
}
multilib_src_install_all(){
	insinto /usr/share/X11/xorg.conf.d/
	doins ${T}/10-amdvlk-dri3.conf
	einfo "AMDVLK Requires DRI3 so istalled /usr/share/X11/xorg.conf.d/10-amdvlk-dri3.conf"
	einfo "It's safe to double xorg configuration files if you have already had ones"
}
pkg_postinst() {
	elog "More information about the configuration can be found here:"
	elog " https://github.com/GPUOpen-Drivers/AMDVLK"
	ewarn "Make sure following line is NOT included in the any Xorg configuration section: "
	ewarn "Driver      \"modesetting\""
	ewarn "With some games AMDVLK is still not stable. Use it at you own risk"
	ewarn "You may want to disable package.use media-libs/mesa -vulkan"
	ewarn "or perform export via /etc/env.d/ variable VK_ICD_FILENAMES=vulkanprovidername "
	ewarn "exampe| VK_ICD_FILENAMES=\"/usr/share/vulkan/icd.d/amd_icd64.json:/usr/share/vulkan/icd.d/amd_icd64.json\""
}
