# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for the internet super-server daemon"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND="|| ( sys-apps/xinetd
		sys-apps/netkit-base
		sys-apps/ucspi-tcp
		dev-python/twisted-runner
		net-misc/ipsvd
		sys-freebsd/freebsd-usbin )"
