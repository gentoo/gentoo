# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/icc/icc-13.1.5.192.ebuild,v 1.3 2014/03/22 12:28:48 jlec Exp $

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=3266
INTEL_DPV=2013_update4
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel C/C++ Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse linguas_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	!dev-lang/ifc[linguas_ja]
	eclipse? ( dev-util/eclipse-sdk )"
RDEPEND="${DEPEND}
	~dev-libs/intel-common-${PV}[compiler,multilib=]"

INTEL_BIN_RPMS="compilerproc compilerproc-devel"
INTEL_DAT_RPMS="compilerproc-common"

CHECKREQS_DISK_BUILD=325M

src_install() {
	if ! use linguas_ja; then
		find "${S}" -type d -name ja_JP -exec rm -rf '{}' + || die
	fi
	intel-sdp_src_install
}
