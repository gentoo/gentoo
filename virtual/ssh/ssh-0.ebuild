# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/ssh/ssh-0.ebuild,v 1.5 2014/03/31 20:31:02 ulm Exp $

EAPI=5

DESCRIPTION="Virtual for SSH client and server"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="minimal"

RDEPEND="minimal? (
		|| ( net-misc/dropbear net-misc/openssh )
	)
	!minimal? (
		|| ( net-misc/openssh net-misc/dropbear )
	)"
