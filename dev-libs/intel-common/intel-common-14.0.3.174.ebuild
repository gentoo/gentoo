# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/intel-common/intel-common-14.0.3.174.ebuild,v 1.1 2014/06/02 10:32:05 jlec Exp $

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=4220
INTEL_DPV=2013_sp1_update3
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp

DESCRIPTION="Common libraries and utilities needed for Intel compilers and libraries"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-compilers/"

IUSE="+compiler"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

CHECKREQS_DISK_BUILD=375M

pkg_setup() {
	einfo ${INTEL_SDP_EDIR}
	INTEL_BIN_RPMS="openmp openmp-devel"
	INTEL_DAT_RPMS="compilerpro-common"
	if use compiler; then
		INTEL_BIN_RPMS+=" compilerpro-devel sourcechecker-devel"
		INTEL_DAT_RPMS+=" compilerpro-vars sourcechecker-common"
	fi
	intel-sdp_pkg_setup
}

src_install() {
	intel-sdp_src_install
	local path rootpath ldpath arch fenv=35intelsdp
	cat > ${fenv} <<-EOF
		NLSPATH=${INTEL_SDP_EDIR}/lib/locale/en_US/%N
		INTEL_LICENSE_FILE="${INTEL_SDP_EDIR}"/licenses:"${EPREFIX}/opt/intel/license"
	EOF
	for arch in ${INTEL_ARCH}; do
			path=${path}:${INTEL_SDP_EDIR}/bin/${arch}:${INTEL_SDP_EDIR}/mpirt/bin/${arch}
			rootpath=${rootpath}:${INTEL_SDP_EDIR}/bin/${arch}:${INTEL_SDP_EDIR}/mpirt/bin/${arch}
			ldpath=${ldpath}:${INTEL_SDP_EDIR}/compiler/lib/${arch}:${INTEL_SDP_EDIR}/mpirt/lib/${arch}
	done
	cat >> ${fenv} <<-EOF
		PATH=${path#:}
		ROOTPATH=${rootpath#:}
		LDPATH=${ldpath#:}
	EOF

	doenvd ${fenv}

	cat >> "${T}"/40-${PN} <<- EOF
	SEARCH_DIRS_MASK="${INTEL_SDP_EDIR}"
	EOF
	insinto /etc/revdep-rebuild/
	doins "${T}"/40-${PN}
}
