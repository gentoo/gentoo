# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/acl/acl-0-r1.ebuild,v 1.4 2014/01/18 01:42:41 vapier Exp $

EAPI="3"

DESCRIPTION="Virtual for acl support (sys/acl.h)"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE="static-libs"

DEPEND=""
RDEPEND="kernel_linux? ( sys-apps/acl[static-libs?] )
	kernel_FreeBSD? ( sys-freebsd/freebsd-lib )"
