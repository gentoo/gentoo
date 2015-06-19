# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/inetd/inetd-0.ebuild,v 1.3 2014/01/18 12:05:06 vapier Exp $

DESCRIPTION="Virtual for the internet super-server daemon"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

DEPEND=""
RDEPEND="|| ( sys-apps/xinetd
		sys-apps/netkit-base
		sys-apps/ucspi-tcp
		dev-python/twisted-runner
		net-misc/ipsvd
		sys-freebsd/freebsd-usbin )"
