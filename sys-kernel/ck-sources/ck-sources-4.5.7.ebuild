# Copyright 1999-2016 Gentoo Foundation
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
K_GENPATCHES_VER="9"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"

inherit kernel-2

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Con Kolivas' high performance patchset and Gentoo's genpatches for Linux ${K_BRANCH_ID}"

#-- If Gentoo-Sources don't follow then extra incremental patches are needed -

XTRA_INCP_MIN=""
XTRA_INCP_MAX=""

#-- Until BFQ patches make it into the genpatches list again

BFQ_VERSION="4.5.0-v7r11"
BFQ_FILE1="0001-block-cgroups-kconfig-build-bits-for-BFQ-v7r11-4.5.0.patch"
BFQ_FILE2="0002-block-introduce-the-BFQ-v7r11-I-O-sched-for-4.5.0.patch"
BFQ_FILE3="0003-block-bfq-add-Early-Queue-Merge-EQM-to-BFQ-v7r11-for.patch"

BFQ_BASE_URL="http://algo.ing.unimo.it/people/paolo/disk_sched/patches"
BFQ_LVER_URL="${BFQ_BASE_URL}/${BFQ_VERSION}"
BFQ_URI="${BFQ_LVER_URL}/${BFQ_FILE1} ${BFQ_LVER_URL}/${BFQ_FILE2} ${BFQ_LVER_URL}/${BFQ_FILE3}"

BFQ_FILE="${DISTDIR}/${BFQ_FILE1} ${DISTDIR}/${BFQ_FILE2} ${DISTDIR}/${BFQ_FILE3}"

#--

CK_VERSION="1"

CK_FILE="patch-${K_BRANCH_ID}-ck${CK_VERSION}.xz"

CK_BASE_URL="http://ck.kolivas.org/patches/4.0"
CK_LVER_URL="${CK_BASE_URL}/${K_BRANCH_ID}/${K_BRANCH_ID}-ck${CK_VERSION}"
CK_URI="${CK_LVER_URL}/${CK_FILE}"

#-- Build extra incremental patches list --------------------------------------

LX_INCP_URI=""
LX_INCP_LIST=""
if [[ -n "${XTRA_INCP_MIN}" ]]; then
	LX_INCP_URL="${KERNEL_BASE_URI}/incr"
	for i in `seq ${XTRA_INCP_MIN} ${XTRA_INCP_MAX}`; do
		LX_INCP[i]="patch-${K_BRANCH_ID}.${i}-$(($i+1)).bz2"
		LX_INCP_URI="${LX_INCP_URI} ${LX_INCP_URL}/${LX_INCP[i]}"
		LX_INCP_LIST="${LX_INCP_LIST} ${DISTDIR}/${LX_INCP[i]}"
	done
fi

#-- CK needs sometimes to patch itself... ---------------------------

CK_INCP_URI=""
CK_INCP_LIST=""

#-- Local patches needed for the ck-patches to apply smoothly -------

PRE_CK_FIX=""
POST_CK_FIX=""

#--

SRC_URI="${KERNEL_URI} ${LX_INCP_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_INCP_URI} ${CK_URI} ${BFQ_URI}"

UNIPATCH_LIST="${LX_INCP_LIST} ${BFQ_FILE} ${PRE_CK_FIX} ${DISTDIR}/${CK_FILE} ${CK_INCP_LIST} ${POST_CK_FIX}"
UNIPATCH_STRICTORDER="yes"

#-- Since experimental genpatches && we want BFQ irrespective of experimental -

K_EXP_GENPATCHES_LIST="50*_*.patch*"

pkg_setup() {
	detect_version || die
	detect_arch || die
}

src_prepare() {

#-- Comment out CK's EXTRAVERSION in Makefile ---------------------------------

	sed -i -e 's/\(^EXTRAVERSION :=.*$\)/# \1/' "${S}/Makefile" || die
}

pkg_postinst() {

	kernel-2_pkg_postinst

	elog
	elog "For more info on this patchset, see: https://forums.gentoo.org/viewtopic-t-941030-start-0.html"
	elog
}
