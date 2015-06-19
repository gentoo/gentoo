# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/idb/idb-13.0.1.117-r1.ebuild,v 1.3 2013/02/14 15:24:27 jlec Exp $

EAPI=4

INTEL_DPN=parallel_studio_xe
INTEL_DID=2872
INTEL_DPV=2013_update1
INTEL_SUBDIR=composerxe

inherit intel-sdp

DESCRIPTION="Intel C/C++/FORTRAN debugger"
HOMEPAGE="http://software.intel.com/en-us/articles/intel-composer-xe/"

IUSE="eclipse"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="~dev-libs/intel-common-${PV}[compiler]"
RDEPEND="${DEPEND}
	virtual/jre
	eclipse? ( dev-util/eclipse-sdk )"

INTEL_BIN_RPMS="idb"
INTEL_DAT_RPMS="idb-common idbcdt"

src_prepare() {
	sed \
		-e "/^INSTALLDIR/s:=.*:=${INTEL_SDP_EDIR}:g" \
		-i ${INTEL_SDP_DIR}/bin/intel*/idb || die
}
