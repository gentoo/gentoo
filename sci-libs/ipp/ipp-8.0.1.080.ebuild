# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=3447
INTEL_DPV=2013_sp1
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp

DESCRIPTION="Intel Integrated Performance Primitive library for multimedia and data processing"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-libs/intel-common-13.1"
DEPEND=""

CHECKREQS_DISK_BUILD=8000M

INTEL_BIN_RPMS="ipp-common-devel ipp-mt ipp-mt-devel ipp-perftest ipp-perftest-devel ipp-st ipp-st-devel"
INTEL_DAT_RPMS="ipp-common"

INTEL_SKIP_LICENSE=true
