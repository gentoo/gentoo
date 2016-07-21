# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2749
INTEL_DPV=2013
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel Integrated Performance Primitive library for multimedia and data processing"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-libs/intel-common-13"
DEPEND=""

CHECKREQS_DISK_BUILD=3000M

INTEL_BIN_RPMS="ipp ipp-devel"
INTEL_DAT_RPMS="ipp-common"
