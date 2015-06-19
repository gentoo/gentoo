# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/linux-headers/linux-headers-2.4.33.3.ebuild,v 1.6 2013/03/09 21:07:33 tomwij Exp $

EAPI="5"

ETYPE="headers"
H_SUPPORTEDARCH="alpha amd64 arm m68k ppc sh sparc x86"
inherit eutils kernel-2
detect_version

PATCHES_V="1"

SRC_URI="${KERNEL_URI} mirror://gentoo/gentoo-headers-${OKV}-${PATCHES_V}.tar.bz2"

KEYWORDS="-* alpha -amd64 arm hppa ia64 m68k -mips ppc ppc64 s390 sh sparc x86"

UNIPATCH_LIST="${DISTDIR}/gentoo-headers-${OKV}-${PATCHES_V}.tar.bz2"
