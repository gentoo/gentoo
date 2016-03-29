# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit multilib-build

DESCRIPTION="Virtual for acl support (sys/acl.h)"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND="kernel_linux? ( >=sys-apps/acl-2.2.52-r1[static-libs?,${MULTILIB_USEDEP}] )
	kernel_FreeBSD? ( >=sys-freebsd/freebsd-lib-9.1-r10[${MULTILIB_USEDEP}] )"
