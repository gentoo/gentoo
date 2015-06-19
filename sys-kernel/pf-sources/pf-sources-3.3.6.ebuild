# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/pf-sources/pf-sources-3.3.6.ebuild,v 1.3 2013/03/09 21:07:31 tomwij Exp $

EAPI="5"

inherit versionator

COMPRESSTYPE=".bz2"
K_USEPV="yes"
UNIPATCH_STRICTORDER="yes"
K_SECURITY_UNSUPPORTED="1"

CKV="$(get_version_component_range 1-2)"
ETYPE="sources"
inherit kernel-2
detect_version
K_NOSETEXTRAVERSION="don't_set_it"

DESCRIPTION="Linux kernel fork with new features, including the -ck patchset (BFS), BFQ, TuxOnIce and UKSM"
HOMEPAGE="http://pf.natalenko.name/"

PF_FILE="patch-${PV}-pf${COMPRESSTYPE}"
PF_URI="http://pf.natalenko.name/sources/$(get_version_component_range 1-2)/${PF_FILE}"
EXPERIMENTAL_PATCHES=(
	# http://ck-hack.blogspot.com/2010/11/create-task-groups-by-tty-comment.html
	# http://ck.kolivas.org/patches/bfs/bfs357-penalise_fork_depth_account_threads.patch
)
EXPERIMENTAL_URI="
	experimental? (
		${EXPERIMENTAL_PATCHES[@]}
	)
"
SRC_URI="${KERNEL_URI} ${PF_URI}" # \${EXPERIMENTAL_URI}

KEYWORDS="-* ~amd64 ~ppc ~ppc64 ~x86"
IUSE="" # experimental

KV_FULL="${PVR}-pf"
S="${WORKDIR}"/linux-"${KV_FULL}"

pkg_setup(){
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the pf developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	kernel-2_pkg_setup
}

src_prepare(){
	epatch "${DISTDIR}"/"${PF_FILE}"
}

pkg_postinst() {
	kernel-2_pkg_postinst

	elog
	elog "${P} has the following optional runtime dependencies:"
	elog "  sys-apps/tuxonice-userui"
	elog "    provides minimal userspace progress information related to"
	elog "    suspending and resuming process"
	elog "  sys-power/hibernate-script or sys-power/pm-utils"
	elog "    runtime utilites for hibernating and suspending your computer"
	elog
}

K_EXTRAEINFO="For more info on pf-sources and details on how to report problems,
see: ${HOMEPAGE}."
