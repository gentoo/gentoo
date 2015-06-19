# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ifc/ifc-13.0.1.117.ebuild,v 1.3 2014/03/22 12:25:41 jlec Exp $

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2872
INTEL_DPV=2013_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="~dev-libs/intel-common-${PV}[compiler,multilib=]"
DEPEND="${RDEPEND}"

INTEL_BIN_RPMS="compilerprof compilerprof-devel"
INTEL_DAT_RPMS="compilerprof-common"

CHECKREQS_DISK_BUILD=300M

src_install() {
	rm ${INTEL_SDP_DIR}/Documentation/ja_JP/gs_resources/intel_logo.gif || die
	intel-sdp_src_install
	local i
	local idir=${INTEL_SDP_EDIR}/compiler/lib
	for i in ${idir}/{ia32,intel64}/locale/ja_JP/{diagspt,flexnet,helpxi}.cat; do
		if [[ -e "${i}" ]]; then
			rm -rvf "${D}${i}" || die
		fi
	done
}
