# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libxshmfence/libxshmfence-1.1.ebuild,v 1.15 2015/03/03 11:47:05 dlan Exp $

EAPI=5
XORG_MULTILIB=yes
inherit xorg-2

DESCRIPTION="Shared memory fences using futexes"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND=">=x11-proto/xproto-7.0.24[${MULTILIB_USEDEP}]
	${RDEPEND}"
