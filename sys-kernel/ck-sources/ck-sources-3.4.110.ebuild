# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"
IUSE="bfsonly experimental urwlocks"

HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://users.tpg.com.au/ckolivas/kernel/"

K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="93"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"

inherit kernel-2
detect_version
detect_arch

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Con Kolivas' high performance patchset and Gentoo's genpatches for Linux ${K_BRANCH_ID}"

#-- If Gentoo-Sources don't follow then extra incremental patches are needed -

XTRA_INCP_MIN=""
XTRA_INCP_MAX=""

#--

CK_VERSION="3"
BFS_VERSION="424"

CK_FILE="patch-${K_BRANCH_ID}-ck${CK_VERSION}.bz2"
BFS_FILE="${K_BRANCH_ID}-sched-bfs-${BFS_VERSION}.patch"
XPR_1_FILE="bfs${BFS_VERSION}-grq_urwlocks.patch"
XPR_2_FILE="urw-locks.patch"

CK_BASE_URL="http://ck.kolivas.org/patches/3.0"
CK_LVER_URL="${CK_BASE_URL}/${K_BRANCH_ID}/${K_BRANCH_ID}-ck${CK_VERSION}"
CK_URI="${CK_LVER_URL}/${CK_FILE}"
BFS_URI="${CK_LVER_URL}/patches/${BFS_FILE}"
XPR_1_URI="${CK_LVER_URL}/patches/${XPR_1_FILE}"
XPR_2_URI="${CK_LVER_URL}/patches/${XPR_2_FILE}"

#-- Build extra incremental patches list --------------------------------------

LX_INCP_URI=""
LX_INCP_LIST=""
if [ -n "${XTRA_INCP_MIN}" ]; then
	LX_INCP_URL="${KERNEL_BASE_URI}/incr"
	for i in `seq ${XTRA_INCP_MIN} ${XTRA_INCP_MAX}`; do
		LX_INCP[i]="patch-${K_BRANCH_ID}.${i}-$(($i+1)).bz2"
		LX_INCP_URI="${LX_INCP_URI} ${LX_INCP_URL}/${LX_INCP[i]}"
		LX_INCP_LIST="${LX_INCP_LIST} ${DISTDIR}/${LX_INCP[i]}"
	done
fi

#-- CK needs sometimes to patch itself... -------------------------------------

CK_INCP_URI=""
CK_INCP_LIST=""

#-- Local patches needed for the ck-patches to apply smoothly -----------------

PRE_CK_FIX="${FILESDIR}/${PN}-3.4-3.5-PreCK-Sched_Fix_Race_In_Task_Group-aCOSwt_P4.patch"
POST_CK_FIX="${FILESDIR}/${PN}-3.4-3.5-PostCK-Sched_Fix_Race_In_Task_Group-aCOSwt_P5.patch ${FILESDIR}/${PN}-3.4.9-calc_load_idle-aCOSwt_P3.patch"
POST_CK_FIX="${POST_CK_FIX} ${FILESDIR}/${PN}-3.4.81-update_cpu_load-aCOSwt_P9.patch"

#--

SRC_URI="${KERNEL_URI} ${LX_INCP_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_INCP_URI}
	!bfsonly? ( ${CK_URI} )
	bfsonly? ( ${BFS_URI} )
	experimental? (
		urwlocks? ( ${XPR_1_URI} ${XPR_2_URI} ) )"

src_unpack() {
	UNIPATCH_LIST="${LX_INCP_LIST} ${PRE_CK_FIX} ${DISTDIR}"
	UNIPATCH_STRICTORDER="yes"

	if ! use bfsonly ; then
		UNIPATCH_LIST="${UNIPATCH_LIST}/${CK_FILE}"
	else
		UNIPATCH_LIST="${UNIPATCH_LIST}/${BFS_FILE}"
	fi

	UNIPATCH_LIST="${UNIPATCH_LIST} ${CK_INCP_LIST} ${POST_CK_FIX}"

	if use experimental ; then
		if use urwlocks ; then
			UNIPATCH_LIST="${UNIPATCH_LIST} ${DISTDIR}/${XPR_1_FILE} ${DISTDIR}/${XPR_2_FILE}:1"
		fi
	fi

	kernel-2_src_unpack
}

src_prepare() {
	#-- Comment out CK's EXTRAVERSION in Makefile ---------------------------------
	sed -i -e 's/\(^EXTRAVERSION :=.*$\)/# \1/' "${S}/Makefile"
}

pkg_postinst() {

	kernel-2_pkg_postinst

	elog
	elog "For more info on this patchset, see: https://forums.gentoo.org/viewtopic-t-941030-start-0.html"
	elog
}
