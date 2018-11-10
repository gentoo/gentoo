# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

SUPER_PN='amdgpu-pro'
MY_PV=$(ver_rs 2 '-')

DESCRIPTION="Proprietary OpenCL implementation for AMD GPUs"
HOMEPAGE="https://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-with-Vulkan-1.1-support.aspx"
SRC_URI="${SUPER_PN}-${MY_PV}.tar.xz"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror fetch strip"

COMMON="app-eselect/eselect-opencl
	dev-libs/ocl-icd"
DEPEND="${COMMON}
	dev-util/patchelf"
RDEPEND="${COMMON}"

QA_PREBUILT="/opt/${SUPER_PN}/lib*/*"

S="${WORKDIR}/${SUPER_PN}-${MY_PV}"

pkg_nofetch() {
	local pkgver=$(ver_cut 1-2)
	einfo "Please download the Radeon Software for Linux Driver ${pkgver} for Ubuntu from"
	einfo "    ${HOMEPAGE}"
	einfo "The archive should then be placed in your distfiles directory."
}

src_unpack() {
	default

	local ids_ver="1.0.0"
	local libdrm_ver="2.4.82"
	local patchlevel=$(ver_cut 3)
	cd "${S}" || die
	unpack_deb opencl-${SUPER_PN}-icd_${MY_PV}_amd64.deb
	unpack_deb libdrm-amdgpu-amdgpu1_${libdrm_ver}-${patchlevel}_amd64.deb
	unpack_deb ids-amdgpu_${ids_ver}-${patchlevel}_all.deb
}

src_prepare() {
	default

	cd "${S}/opt/${SUPER_PN}/lib/x86_64-linux-gnu" || die
	patchelf --set-rpath '$ORIGIN' libamdocl64.so || die "Failed to fix library rpath"
}

src_install() {
	into "/opt/amdgpu"
	dolib.so opt/${SUPER_PN}/lib/x86_64-linux-gnu/*
	dolib.so opt/amdgpu/lib/x86_64-linux-gnu/*
	insinto "/opt/amdgpu"
	doins -r opt/amdgpu/share

	insinto /etc/OpenCL/vendors/
	echo "/opt/amdgpu/$(get_libdir)/libamdocl64.so" > "${SUPER_PN}.icd" || die "Failed to generate ICD file"
	doins "${SUPER_PN}.icd"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		ewarn "Please note that using proprietary OpenCL libraries together with the"
		ewarn "Open Source amdgpu stack is not officially supported by AMD. Do not ask them"
		ewarn "for support in case of problems with this package."
		ewarn ""
		ewarn "Furthermore, if you have the whole AMDGPU-Pro stack installed this package"
		ewarn "will almost certainly conflict with it. This might change once AMDGPU-Pro"
		ewarn "has become officially supported by Gentoo."
	fi

	"${ROOT}"/usr/bin/eselect opencl set --use-old ocl-icd
}
