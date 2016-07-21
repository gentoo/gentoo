# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit rpm multilib

DESCRIPTION="Intel's implementation of the OpenCL standard"
HOMEPAGE="http://software.intel.com/en-us/articles/opencl-sdk/"
SRC_URI="http://registrationcenter.intel.com/irc_nas/4181/intel_sdk_for_ocl_applications_2014_ubuntu_${PV}_x64.tgz"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="android +system-tbb system-clang +system-boost +system-qt"
KEYWORDS="-* ~amd64"
RESTRICT="mirror"

RDEPEND="app-eselect/eselect-opencl
	sys-process/numactl
	system-tbb? ( >=dev-cpp/tbb-4.2.20131118 )
	system-clang? ( =sys-devel/clang-3.4* )
	system-boost? ( >=dev-libs/boost-1.52.0:= )
	system-qt? (
		>=dev-qt/qtgui-4.8.5:4
		>=dev-qt/qtcore-4.8.5:4
		)
	"
DEPEND=""

S=${WORKDIR}/intel_sdk_for_ocl_applications_2014_ubuntu_${PV}_x64/
INTEL_CL=opt/intel/opencl-1.2-${PV}
INTEL_VENDOR_DIR=usr/$(get_libdir)/OpenCL/vendors/intel/

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
	if use system-clang; then
		rm -f "${WORKDIR}/${INTEL_CL}"/lib64/libclang*
	fi
	if use system-qt; then
		rm -f "${WORKDIR}/${INTEL_CL}"/lib64/libQt*
	fi
	if use system-tbb; then
		rm -f "${WORKDIR}/${INTEL_CL}"/lib64/libtbb*
	fi
}

src_install() {
	insinto /etc/OpenCL/vendors/
	doins "${WORKDIR}/${INTEL_CL}"/etc/intel64.icd

	insinto /"${INTEL_CL}"/lib64
	insopts -m 755
	doins "${WORKDIR}/${INTEL_CL}"/lib64/*

	insinto /"${INTEL_CL}"/bin
	doins "${WORKDIR}"/"${INTEL_CL}"/bin/*

	# TODO put this somewhere
	# doins ${INTEL_CL}/eclipse-plug-in/OpenCL_SDK_0.1.0.jar

	dodir "${INTEL_VENDOR_DIR}"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so"     "${INTEL_VENDOR_DIR}/libOpenCL.so"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1"   "${INTEL_VENDOR_DIR}/libOpenCL.so.1"
	dosym "/opt/intel/opencl-1.2-${PV}/lib64/libOpenCL.so.1.2" "${INTEL_VENDOR_DIR}/libOpenCL.so.1.2"
}

pkg_postinst() {
	eselect opencl set --use-old intel
}
