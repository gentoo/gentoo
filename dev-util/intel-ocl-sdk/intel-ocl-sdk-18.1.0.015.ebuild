# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="Intel's implementation of the OpenCL standard"
HOMEPAGE="https://www.intel.com/content/www/us/en/developer/articles/tool/opencl-drivers.html#cpu-section"
SRC_URI="https://registrationcenter-download.intel.com/akdlm/irc_nas/vcp/15532/l_opencl_p_${PV}.tgz"

LICENSE="Intel-SDP"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror"

RDEPEND="dev-libs/libxml2
	sys-libs/ncurses-compat
	sys-libs/zlib
	sys-process/numactl
	>=virtual/opencl-3"

S="${WORKDIR}/l_opencl_p_${PV}"

INTEL_CL="opt/intel/opencl_compilers_and_libraries_${PV}/linux"
INTEL_INSTALL_PATH="/opt/intel/opencl-${PV}"
INTEL_VENDOR_DIR=usr/lib/OpenCL/vendors/intel
ALT_PV="${PV/.015/-015}"

QA_PREBUILT="${INTEL_INSTALL_PATH}/*"

src_unpack() {
	default
	rpm_unpack "${S}/rpm/intel-openclrt-${PV}-${ALT_PV}.x86_64.rpm"
}

src_install() {
	echo "${EPREFIX}${INTEL_INSTALL_PATH}/lib64/libintelocl.so" > intel64.icd || die
	insinto /etc/OpenCL/vendors/
	doins intel64.icd

	insinto "${INTEL_INSTALL_PATH}"
	insopts -m 755
	doins "${WORKDIR}/${INTEL_CL}/compiler/lib/clbltfnshared.rtl"
	insinto "${INTEL_INSTALL_PATH}/lib64"
	insopts -m 755
	doins "${WORKDIR}/${INTEL_CL}/compiler/lib/intel64_lin/"*

	dodir "${INTEL_VENDOR_DIR}"
	dosym -r "${INTEL_INSTALL_PATH}/lib64/libOpenCL.so"     "${INTEL_VENDOR_DIR}/libOpenCL.so"
	dosym -r "${INTEL_INSTALL_PATH}/lib64/libOpenCL.so.1"   "${INTEL_VENDOR_DIR}/libOpenCL.so.1"
	dosym -r "${INTEL_INSTALL_PATH}/lib64/libOpenCL.so.2.0" "${INTEL_VENDOR_DIR}/libOpenCL.so.2.0"
}
