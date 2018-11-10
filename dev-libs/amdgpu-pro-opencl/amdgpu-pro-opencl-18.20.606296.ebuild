# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

SUPER_PN='amdgpu-pro'
MY_PV=$(ver_rs 2 '-')

DESCRIPTION="Proprietary OpenCL implementation for AMD GPUs"
HOMEPAGE="https://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-Release-Notes.aspx"
SRC_URI="${SUPER_PN}-${MY_PV}.tar.xz"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror fetch strip"

COMMON="app-eselect/eselect-opencl
	dev-libs/ocl-icd"
DEPEND="${COMMON}"
RDEPEND="${COMMON}"

QA_PREBUILT="/opt/${SUPER_PN}/lib*/*"

S="${WORKDIR}/${SUPER_PN}-${MY_PV}"

pkg_nofetch() {
	local pkgver=$(ver_cut 1-2)
	einfo "Please download the Radeon Software for Linux Driver ${pkgver} for Ubuntu 16 from"
	einfo "    ${HOMEPAGE}"
	einfo "The archive should then be placed in your distfiles directory."
}

src_unpack() {
	default

	cd "${S}" || die
	unpack_deb opencl-orca-amdgpu-pro-icd_${MY_PV}_amd64.deb
}

src_install() {
	into "/opt/amdgpu"
	dolib.so opt/${SUPER_PN}/lib/x86_64-linux-gnu/*

	insinto /etc/OpenCL/vendors/
	echo "/opt/amdgpu/$(get_libdir)/libamdocl-orca64.so" > "${SUPER_PN}.icd" || die "Failed to generate ICD file"
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
