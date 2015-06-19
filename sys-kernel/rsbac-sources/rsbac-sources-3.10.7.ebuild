# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/rsbac-sources/rsbac-sources-3.10.7.ebuild,v 1.1 2013/08/20 15:52:22 blueness Exp $

EAPI="5"

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="13"

inherit kernel-2
detect_version

RSBC_VER="1.4.7"
RSBC_PATCH="patch-linux-${PV}-rsbac-${RSBC_VER}.diff.xz"

HGPV_URI="http://download.rsbac.org/patches/${RSBC_VER}/${RSBC_PATCH}"
SRC_URI="${KERNEL_URI} ${HGPV_URI} ${GENPATCHES_URI} ${ARCH_URI}"

UNIPATCH_LIST="${DISTDIR}/${RSBC_PATCH}"
UNIPATCH_EXCLUDE="4200_fbcondecor-0.9.6.patch"

DESCRIPTION="RSBAC kernel sources (kernel series ${KV_MAJOR}.${KV_MINOR})"
HOMEPAGE="http://www.gentoo.org/proj/en/hardened/"
IUSE=""

KEYWORDS="~amd64 ~x86"
