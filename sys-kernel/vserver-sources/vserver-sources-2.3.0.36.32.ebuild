# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/vserver-sources/vserver-sources-2.3.0.36.32.ebuild,v 1.5 2014/08/10 20:18:54 slyfox Exp $

EAPI="5"

ETYPE="sources"
CKV="2.6.35"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="9"

K_USEPV=1
K_NOSETEXTRAVERSION=1

MY_PN=${PN/-sources/-patches}

inherit kernel-2
detect_version

KEYWORDS="amd64 hppa x86"
IUSE=""

DESCRIPTION="Full sources including Gentoo and Linux-VServer patchsets for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
HOMEPAGE="http://www.gentoo.org/proj/en/vps/"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	http://dev.gentoo.org/~hollow/distfiles/${MY_PN}-${CKV}_${PVR}.tar.bz2"

UNIPATCH_LIST="${DISTDIR}/${MY_PN}-${CKV}_${PVR}.tar.bz2"
