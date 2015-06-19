# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/idb/idb-13.0.0.079.ebuild,v 1.2 2013/02/14 10:33:41 jlec Exp $

EAPI=4
INTEL_DPN=parallel_studio_xe
INTEL_DID=2749
INTEL_DPV=2013
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel C/C++/FORTRAN debugger"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="~dev-libs/intel-common-${PV}[compiler]"
RDEPEND="${DEPEND}
	eclipse? ( dev-util/eclipse-sdk )"

INTEL_BIN_RPMS="idb"
INTEL_DAT_RPMS="idb-common idbcdt"
