# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Define what default functions to run
ETYPE="sources"

# No 'experimental' USE flag provided, but we still want to use genpatches
K_EXP_GENPATCHES_NOUSE="1"

# Just get basic genpatches, -pf patch set already includes vanilla-linux updates
K_GENPATCHES_VER="4"

# -pf already sets EXTRAVERSION to kernel Makefile
K_NOSETEXTRAVERSION="1"

# Not supported by the Gentoo security team
K_SECURITY_UNSUPPORTED="1"

# We want the very basic patches from gentoo-sources, experimental patch is
# already included in pf-sources
K_WANT_GENPATCHES="base extras"

# major kernel version, e.g. 5.14
SHPV="${PV/_p*/}"

# https://gitlab.com/alfredchen/projectc/ revision for a major version,
# e.g. prjc-v5.14-r2 = 2
PRJC_R=2

# These is already patched via -pf patch set.
UNIPATCH_EXCLUDE="1000_linux-${SHPV}.1.patch 1001_linux-${SHPV}.2.patch"

inherit kernel-2 optfeature
detect_version

DESCRIPTION="Linux kernel fork that includes the pf-kernel patchset and Gentoo's genpatches"
HOMEPAGE="https://gitlab.com/post-factum/pf-kernel/-/wikis/README
	https://dev.gentoo.org/~mpagano/genpatches/"
SRC_URI="${KERNEL_URI}
	https://github.com/pfactum/pf-kernel/compare/v${SHPV}...v${SHPV}-pf${PV/*_p/}.diff -> ${P}.patch
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${SHPV}-${K_GENPATCHES_VER}.base.tar.xz
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${SHPV}-${K_GENPATCHES_VER}.extras.tar.xz
	https://gitlab.com/alfredchen/projectc/-/raw/master/${SHPV}/prjc_v${SHPV}-r${PRJC_R}.patch"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

S="${WORKDIR}/linux-${PVR}-pf"

PATCHES=( "${DISTDIR}/${P}.patch"
	"${DISTDIR}/prjc_v${SHPV}-r${PRJC_R}.patch" )

K_EXTRAEINFO="For more info on pf-sources and details on how to report problems,
	see: ${HOMEPAGE}."

pkg_setup() {
	ewarn ""
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the pf developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn ""

	kernel-2_pkg_setup
}

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES().
	default
}

pkg_postinst() {
	kernel-2_pkg_postinst

	optfeature "userspace KSM helper" sys-process/uksmd
}
