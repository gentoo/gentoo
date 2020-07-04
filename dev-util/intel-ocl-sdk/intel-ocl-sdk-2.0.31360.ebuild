# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

MY_P=${PN//-/_}_2012_x64

inherit rpm multilib

INTEL_CL=usr/$(get_libdir)/OpenCL/vendors/intel/

DESCRIPTION="Intel's implementation of the OpenCL standard optimized for Intel processors"
HOMEPAGE="http://software.intel.com/en-us/articles/opencl-sdk/"
SRC_URI="http://registrationcenter.intel.com/irc_nas/2563/intel_sdk_for_ocl_applications_2012_x64.tgz"

LICENSE="Intel-SDP"
SLOT="0"
IUSE="tools"
KEYWORDS="amd64 -x86"

RDEPEND="app-eselect/eselect-opencl
	dev-cpp/tbb
	sys-process/numactl
	tools? (
		sys-devel/llvm
		>=virtual/jre-1.6
	)"
DEPEND=""

RESTRICT="bindist mirror"
QA_EXECSTACK="${INTEL_CL/\//}libcpu_device.so
	${INTEL_CL/\//}libOclCpuBackEnd.so
	${INTEL_CL/\//}libtask_executor.so"
QA_PREBUILT="${INTEL_CL}*"

S=${WORKDIR}

src_unpack() {
	default
	rpm_unpack ./${MY_P}.rpm
}

src_prepare() {
	# Remove unnecessary and bundled stuff
	rm -rf ${INTEL_CL}/{docs,version.txt,llc}
	rm -f ${INTEL_CL}/libboost*.so
	rm -f ${INTEL_CL}/libtbb*
	if ! use tools; then
		rm -rf usr/bin
		rm -f ${INTEL_CL}/{ioc64,ioc.jar}
		rm -f ${INTEL_CL}/libboost*
	fi
}

src_install() {
	doins -r etc

	insinto ${INTEL_CL}
	doins -r usr/include

	insopts -m 755
	newins usr/$(get_libdir)/libOpenCL.so libOpenCL.so.1
	dosym libOpenCL.so.1 ${INTEL_CL}/libOpenCL.so

	doins ${INTEL_CL}/*
}

pkg_postinst() {
	eselect opencl set --use-old intel
}
