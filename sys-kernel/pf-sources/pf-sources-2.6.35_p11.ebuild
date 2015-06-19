# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/pf-sources/pf-sources-2.6.35_p11.ebuild,v 1.3 2013/03/09 21:07:31 tomwij Exp $

EAPI="5"

COMPRESSTYPE=".bz2"
K_USEPV="yes"
UNIPATCH_STRICTORDER="yes"
K_SECURITY_UNSUPPORTED="1"

CKV="${PV/_p[0-9]*}"
ETYPE="sources"
inherit kernel-2
detect_version
K_NOSETEXTRAVERSION="don't_set_it"

DESCRIPTION="Linux kernel fork with new features, including the -ck patchset (BFS), BFQ, TuxOnIce and LinuxIMQ"
HOMEPAGE="http://pf.natalenko.name/"

PF_PATCHSET="${PV/*_p}"
PF_KERNEL="${PV/_p[0-9]*}"
PF_KERNEL="${PF_KERNEL/_/-}"
PF_FILE="patch-${PF_KERNEL}-pf${PF_PATCHSET}${COMPRESSTYPE}"
PF_URI="http://pf.natalenko.name/sources/$(get_version_component_range 1-3)/${PF_FILE}"
SRC_URI="${KERNEL_URI} ${PF_URI}"

KEYWORDS="-* ~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

KV_FULL="${PVR/_p/-pf}"
S="${WORKDIR}"/linux-"${KV_FULL}"

pkg_setup(){
	ewarn
	ewarn "${PN} is *not* supported by the Gentoo Kernel Project in any way."
	ewarn "If you need support, please contact the pf developers directly."
	ewarn "Do *not* open bugs in Gentoo's bugzilla unless you have issues with"
	ewarn "the ebuilds. Thank you."
	ewarn
	ebeep 8
	kernel-2_pkg_setup
}

src_prepare(){
	epatch "${DISTDIR}"/"${PF_FILE}"
}

K_EXTRAEINFO="For more info on pf-sources and details on how to report problems, see: \
${HOMEPAGE}."
