# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://users.tpg.com.au/ckolivas/kernel/"

K_WANT_GENPATCHES="base extras experimental"
K_EXP_GENPATCHES_PULL="1"
K_EXP_GENPATCHES_NOUSE="1"
K_GENPATCHES_VER="1"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"

inherit kernel-2
detect_version
detect_arch

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Con Kolivas' high performance patchset and Gentoo's genpatches for Linux ${K_BRANCH_ID}"

CK_VERSION="1"

CK_FILE="patch-${K_BRANCH_ID}-ck${CK_VERSION}.xz"

CK_BASE_URL="http://ck.kolivas.org/patches/4.0"
CK_LVER_URL="${CK_BASE_URL}/${K_BRANCH_ID}/${K_BRANCH_ID}-ck${CK_VERSION}"
CK_URI="${CK_LVER_URL}/${CK_FILE}"

SRC_URI="${KERNEL_URI} ${ARCH_URI} ${CK_URI}"

UNIPATCH_LIST="${DISTDIR}/${CK_FILE}"
UNIPATCH_STRICTORDER="yes"

#-- Starting with 4.8, CK patches include BFQ, so exclude genpatches experimental BFQ patches -

K_EXP_GENPATCHES_LIST="5010_*.patch*"

src_prepare() {

#-- Comment out CK's EXTRAVERSION in Makefile ---------------------------------

	# linux-info eclass cannot handle recursively expanded variables in Makefile #490328
	sed -i -e 's/\(^EXTRAVERSION :=.*$\)/# \1/' "${S}/Makefile" || die
}
