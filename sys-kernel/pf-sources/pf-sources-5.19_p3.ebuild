# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Define what default functions to run
ETYPE="sources"

# No 'experimental' USE flag provided, but we still want to use genpatches
K_EXP_GENPATCHES_NOUSE="1"

# Just get basic genpatches, -pf patch set already includes vanilla-linux updates
K_GENPATCHES_VER="1"

# -pf already sets EXTRAVERSION to kernel Makefile
K_NOSETEXTRAVERSION="1"

# Not supported by the Gentoo security team
K_SECURITY_UNSUPPORTED="1"

# We want the very basic patches from gentoo-sources, experimental patch is
# already included in pf-sources
K_WANT_GENPATCHES="base extras"

# major kernel version, e.g. 5.14
SHPV="${PV/_p*/}"

# Replace "_p" with "-pf"
PFPV="${PV/_p/-pf}"

# https://gitlab.com/alfredchen/projectc/ revision for a major version,
# e.g. prjc-v5.14-r2 = 2
PRJC_R=0

inherit kernel-2 optfeature
detect_version

DESCRIPTION="Linux kernel fork that includes the pf-kernel patchset and Gentoo's genpatches"
HOMEPAGE="https://codeberg.org/pf-kernel/linux/wiki/README
	https://dev.gentoo.org/~mpagano/genpatches/"
SRC_URI="https://codeberg.org/pf-kernel/linux/archive/v${PFPV}.tar.gz -> linux-${PFPV}.tar.gz
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${SHPV}-${K_GENPATCHES_VER}.base.tar.xz
	https://dev.gentoo.org/~mpagano/genpatches/tarballs/genpatches-${SHPV}-${K_GENPATCHES_VER}.extras.tar.xz
	https://gitlab.com/torvic9/linux519-vd/-/raw/master/prjc-519-r1-vd-test.patch"
#	https://gitlab.com/alfredchen/projectc/-/raw/master/${SHPV}/prjc_v${SHPV}-r${PRJC_R}.patch"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

S="${WORKDIR}/linux-${PFPV}"

#PATCHES=( "${DISTDIR}/prjc_v${SHPV}-r${PRJC_R}.patch" )
PATCHES=( "${DISTDIR}/prjc-519-r1-vd-test.patch" )

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

src_unpack() {
	# Since the Codeberg-hosted pf-sources include full kernel sources, we need to manually override
	# the src_unpack phase because kernel-2_src_unpack() does a lot of unwanted magic here.
	unpack ${A}

	mv linux linux-${PFPV} || die "Failed to move source directory"
}

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES(). After pf-sources moved to Codeberg, we need
	# to manually eapply the genpatches too.
	eapply "${WORKDIR}"/*.patch
	default
}

pkg_postinst() {
	# Fixes "wrongly" detected directory name, bgo#862534.
	local KV_FULL="${PFPV}"
	kernel-2_pkg_postinst

	optfeature "userspace KSM helper" sys-process/uksmd
}

pkg_postrm() {
	# Same here, bgo#862534.
	local KV_FULL="${PFPV}"
	kernel-2_pkg_postrm
}
