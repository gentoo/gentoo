# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/acl/acl-0-r2.ebuild,v 1.2 2014/06/18 20:53:07 mgorny Exp $

EAPI="4"

inherit multilib-build

DESCRIPTION="Virtual for acl support (sys/acl.h)"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND="kernel_linux? ( >=sys-apps/acl-2.2.52-r1[static-libs?,${MULTILIB_USEDEP}] )
	kernel_FreeBSD? ( >=sys-freebsd/freebsd-lib-9.1-r10[${MULTILIB_USEDEP}] )"
