# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker versionator

SUPER_PN='amdgpu-pro'
MY_PV=$(replace_version_separator 2 '-')

DESCRIPTION="Proprietary OpenCL implementation for AMD GPUs"
HOMEPAGE="https://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Driver-for-Linux-Release-Notes.aspx"
SRC_URI="${SUPER_PN}-${MY_PV}.tar.xz"

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="mirror fetch strip"

DEPEND="dev-util/patchelf"
RDEPEND="dev-libs/ocl-icd"

QA_PREBUILT="/opt/${SUPER_PN}/lib*/*"

S="${WORKDIR}/${SUPER_PN}-${MY_PV}"

pkg_nofetch() {
	local pkgver=$(get_version_component_range 1-2)
	einfo "Please download the AMDGPU-Pro Driver ${pkgver} for Ubuntu from"
	einfo "    ${HOMEPAGE}"
	einfo "The archive should then be placed into ${DISTDIR}."
}

src_unpack() {
	default

	local libdrm_ver="2.4.70"
	local patchlevel=$(get_version_component_range 3)
	cd "${S}" || die
	unpack_deb opencl-${SUPER_PN}-icd_${MY_PV}_amd64.deb
	unpack_deb libdrm-${SUPER_PN}-amdgpu1_${libdrm_ver}-${patchlevel}_amd64.deb
}

src_prepare() {
	default

	cd "${S}/opt/${SUPER_PN}/lib/x86_64-linux-gnu" || die
	patchelf --set-rpath '$ORIGIN' libamdocl64.so || die "Failed to fix library rpath"
}

src_install() {

	into "/opt/${SUPER_PN}"
	dolib opt/${SUPER_PN}/lib/x86_64-linux-gnu/*

	insinto /etc/OpenCL/vendors/
	echo "/opt/${SUPER_PN}/$(get_libdir)/libamdocl64.so" > "${SUPER_PN}.icd" || die "Failed to generate ICD file"
	doins "${SUPER_PN}.icd"
}

pkg_postinst() {
	elog "AMD OpenCL driver relies on dev-libs/ocl-icd to work. To enable it, please run"
	elog ""
	elog "    eselect opencl set ocl-icd"
	elog ""
}
