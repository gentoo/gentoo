# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/ipp/ipp-8.2.2.187.ebuild,v 1.1 2015/06/24 09:53:49 jlec Exp $

EAPI=5

INTEL_DPN=parallel_studio_xe
INTEL_DID=7538
INTEL_DPV=2015_update3
INTEL_SUBDIR=composerxe
INTEL_SINGLE_ARCH=false

inherit intel-sdp

DESCRIPTION="Intel Integrated Performance Primitive library for multimedia and data processing"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-ipp/"

IUSE=""
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND=">=dev-libs/intel-common-15"
DEPEND=""

CHECKREQS_DISK_BUILD=6400M

INTEL_BIN_RPMS=( ipp-{ac,di,gen,jp,mt,mt-devel,mx,rr,sc,st,st-devel,vc} )
INTEL_DAT_RPMS=( ipp-common ipp-{ac,di,gen,jp,mx,rr,sc,st-devel,vc}-common )

INTEL_SKIP_LICENSE=true
