# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
ETYPE="sources"
KEYWORDS="~amd64 ~x86"

HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches/
	http://users.tpg.com.au/ckolivas/kernel/"

K_WANT_GENPATCHES="base extras experimental"
K_EXP_GENPATCHES_PULL="1"
K_EXP_GENPATCHES_NOUSE="1"
K_GENPATCHES_VER="15"
K_SECURITY_UNSUPPORTED="1"
K_DEBLOB_AVAILABLE="1"

PYTHON_COMPAT=( python2_7 )
inherit python-any-r1 kernel-2
detect_version
detect_arch

DEPEND="deblob? ( ${PYTHON_DEPS} )"

K_BRANCH_ID="${KV_MAJOR}.${KV_MINOR}"

DESCRIPTION="Con Kolivas' high performance patchset and Gentoo's genpatches for Linux ${K_BRANCH_ID}"

#-- If Gentoo-Sources don't follow then extra incremental patches are needed -

XTRA_INCP_MIN=""
XTRA_INCP_MAX=""

#--

CK_VERSION="1"

CK_FILE="patch-${K_BRANCH_ID}-ck${CK_VERSION}.xz"

CK_BASE_URL="http://ck.kolivas.org/patches/4.0"
CK_LVER_URL="${CK_BASE_URL}/${K_BRANCH_ID}/${K_BRANCH_ID}-ck${CK_VERSION}"
CK_URI="${CK_LVER_URL}/${CK_FILE}"

# solves bug #606866 (Fix build for CONFIG_FREEZER disabled.x)
FRZR_HASH="7de569950716147ed436b27936628ee3ab5b45cc"
FRZR_FILE="${PN}-4.9-freezer-fix.patch"
FRZR_URI="https://github.com/ckolivas/linux/commit/${FRZR_HASH}.patch -> ${FRZR_FILE}"

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

#-- CK needs sometimes to patch itself... ---------------------------

CK_INCP_URI=""
CK_INCP_LIST=""

#-- Local patches needed for the ck-patches to apply smoothly -------

PRE_CK_FIX=""
POST_CK_FIX=""

#--

SRC_URI="${KERNEL_URI} ${LX_INCP_URI} ${GENPATCHES_URI} ${ARCH_URI} ${CK_INCP_URI} ${CK_URI} ${FRZR_URI}"

UNIPATCH_LIST="${LX_INCP_LIST} ${PRE_CK_FIX} ${DISTDIR}/${CK_FILE} ${CK_INCP_LIST} ${POST_CK_FIX} ${DISTDIR}/${FRZR_FILE}"
UNIPATCH_STRICTORDER="yes"

#-- Starting with 4.8, CK patches include BFQ, so exclude genpatches experimental BFQ patches -

K_EXP_GENPATCHES_LIST="5010_*.patch*"

pkg_setup() {
	use deblob && python-any-r1_pkg_setup
	kernel-2_pkg_setup
}

src_prepare() {

#-- Comment out CK's EXTRAVERSION in Makefile ---------------------------------

	# linux-info eclass cannot handle recursively expanded variables in Makefile #490328
	sed -i -e 's/\(^EXTRAVERSION :=.*$\)/# \1/' "${S}/Makefile" || die

	kernel-2_src_prepare
}
