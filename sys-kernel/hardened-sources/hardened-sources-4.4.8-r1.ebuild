# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

ETYPE="sources"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="9"
K_DEBLOB_AVAILABLE="1"

inherit kernel-2
detect_version

HGPV="${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}-2"
HGPV_URI="https://dev.gentoo.org/~blueness/hardened-sources/hardened-patches/hardened-patches-${HGPV}.extras.tar.bz2"
SRC_URI="${KERNEL_URI} ${HGPV_URI} ${GENPATCHES_URI} ${ARCH_URI}"

UNIPATCH_LIST="${DISTDIR}/hardened-patches-${HGPV}.extras.tar.bz2"
UNIPATCH_EXCLUDE="
	1500_XATTR_USER_PREFIX.patch
	2900_dev-root-proc-mount-fix.patch"

DESCRIPTION="Hardened kernel sources (kernel series ${KV_MAJOR}.${KV_MINOR})"
HOMEPAGE="https://www.gentoo.org/proj/en/hardened/"
IUSE="deblob"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

RDEPEND=">=sys-devel/gcc-4.5"

pkg_postinst() {
	kernel-2_pkg_postinst

	local GRADM_COMPAT="sys-apps/gradm-3.1*"

	ewarn
	ewarn "Users of grsecurity's RBAC system must ensure they are using"
	ewarn "${GRADM_COMPAT}, which is compatible with ${PF}."
	ewarn "It is strongly recommended that the following command is issued"
	ewarn "prior to booting a ${PF} kernel for the first time:"
	ewarn
	ewarn "emerge -na =${GRADM_COMPAT}"
	ewarn
}
