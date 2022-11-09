# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="Intel's implementation of the OpenCL standard"
HOMEPAGE="https://software.intel.com/en-us/articles/opencl-sdk/"
SRC_URI="https://registrationcenter.intel.com/irc_nas/4181/intel_sdk_for_ocl_applications_2014_ubuntu_${PV}_x64.tgz"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="android +system-tbb +system-boost"
KEYWORDS="-* amd64"
RESTRICT="bindist mirror"

RDEPEND=">=virtual/opencl-3
	sys-process/numactl
	system-tbb? ( >=dev-cpp/tbb-4.2.20131118 )
	system-boost? ( dev-libs/boost:= )
"
DEPEND=""
PDEPEND="
	dev-libs/glib
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrender
	sys-libs/zlib
"

S=${WORKDIR}/intel_sdk_for_ocl_applications_2014_ubuntu_${PV}_x64/
INTEL_CL=opt/intel/opencl-1.2-${PV}

QA_PREBUILT="${INTEL_OCL}/*"

src_unpack() {
	default

	PKGS="base devel intel-cpu intel-devel"

	use android && PKGS="$PKGS intel-devel-android"

	for PKG in ${PKGS}; do
		FILENAME="opencl-1.2-${PKG}-4.4.0.117-1.x86_64.deb"
		einfo "Extracting \"${FILENAME}\"..."
		ar x "${S}/$FILENAME" || die
		unpack ./data.tar.gz
	done
}

src_prepare() {
	# Remove bundled stuff
	if use system-boost; then
		rm -f "${WORKDIR}/${INTEL_CL}"/lib64/libboost*.so*
	fi
	if use system-tbb; then
		rm -f "${WORKDIR}/${INTEL_CL}"/lib64/libtbb*
	fi
	# Prepend EPREFIX to library path in intel64.icd
	if [[ -n ${EPREFIX} ]]; then
		sed -i -e "s@^/opt@${EPREFIX}/opt@" "${WORKDIR}/${INTEL_CL}"/etc/intel64.icd
	fi
	default
}

src_install() {
	insinto /etc/OpenCL/vendors/
	doins "${WORKDIR}/${INTEL_CL}"/etc/intel64.icd

	insinto /"${INTEL_CL}"/lib64
	insopts -m 755
	doins "${WORKDIR}/${INTEL_CL}"/lib64/*

	insinto /"${INTEL_CL}"/bin
	doins "${WORKDIR}"/"${INTEL_CL}"/bin/*

	# fix symlinks for oclopt and clangSpir12 on prefix
	dosym "../lib64/oclopt"      "opt/intel/opencl-1.2-${PV}/bin/oclopt"
	dosym "../lib64/clangSpir12" "opt/intel/opencl-1.2-${PV}/bin/clangSpir12"

	# TODO put this somewhere
	# doins ${INTEL_CL}/eclipse-plug-in/OpenCL_SDK_0.1.0.jar

	INTEL_VENDOR_DIR=usr/lib/OpenCL/vendors/intel/
	dodir "${INTEL_VENDOR_DIR}"
	dosym "../../../../../opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so"     "${INTEL_VENDOR_DIR}/libOpenCL.so"
	dosym "../../../../../opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1"   "${INTEL_VENDOR_DIR}/libOpenCL.so.1"
	dosym "../../../../../opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1.2" "${INTEL_VENDOR_DIR}/libOpenCL.so.1.2"
}
