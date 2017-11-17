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

	local ids_ver="1.0.0"
	local libdrm_ver="2.4.82"
	local patchlevel=$(get_version_component_range 3)
	cd "${S}" || die
	unpack_deb opencl-${SUPER_PN}-icd_${MY_PV}_amd64.deb
	unpack_deb libdrm-${SUPER_PN}-amdgpu1_${libdrm_ver}-${patchlevel}_amd64.deb
	unpack_deb ids-${SUPER_PN}_${ids_ver}-${patchlevel}_all.deb
}

src_prepare() {
	default

	cd "${S}/opt/${SUPER_PN}/lib/x86_64-linux-gnu" || die
	patchelf --set-rpath '$ORIGIN' libamdocl64.so || die "Failed to fix library rpath"
}

src_install() {
	into "/opt/${SUPER_PN}"
	dolib opt/${SUPER_PN}/lib/x86_64-linux-gnu/*
	insinto "/opt/${SUPER_PN}"
	doins -r opt/${SUPER_PN}/share

	insinto /etc/OpenCL/vendors/
	echo "/opt/${SUPER_PN}/$(get_libdir)/libamdocl64.so" > "${SUPER_PN}.icd" || die "Failed to generate ICD file"
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
		ewarn "Enabling Large Page Support"
		ewarn "The syntax of this module parameter is amdgpu.vm_fragment_size=X, where the actual fragment size is 4KB * 2^X. The default is X=4, which means 64KB. To get 2MB fragments, set X=9."
		ewarn "Edit /etc/default/grub as root and modify GRUB_CMDLINE_LINUX in order to add \"amdgpu.vm_fragment_size=9\" (without the quotes). The line may look something like this after the change:"
		ewarn ""
		ewarn "GRUB_CMDLINE_LINUX_DEFAULT=\"quiet splash amdgpu.vm_fragment_size=9\""
	fi

	elog "AMD OpenCL driver relies on dev-libs/ocl-icd to work. To enable it, please run"
	elog ""
	elog "    eselect opencl set ocl-icd"
	elog ""
}
