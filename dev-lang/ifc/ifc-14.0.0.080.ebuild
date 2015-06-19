# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ifc/ifc-14.0.0.080.ebuild,v 1.2 2014/03/22 12:25:41 jlec Exp $

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=3447
INTEL_DPV=2013_sp1
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp

DESCRIPTION="Intel FORTRAN Compiler"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="linguas_ja"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="!dev-lang/ifc[linguas_jp]"
RDEPEND="${DEPEND}
	~dev-libs/intel-common-${PV}[compiler,multilib=]"

INTEL_BIN_RPMS="compilerprof compilerprof-devel"
INTEL_DAT_RPMS="compilerprof-common"

CHECKREQS_DISK_BUILD=375M

src_install() {
	if ! use linguas_ja; then
		find "${S}" -type d -name ja_JP -exec rm -rf '{}' + || die
	fi
	intel-sdp_src_install
}
