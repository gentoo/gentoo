# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/pkgconfig/pkgconfig-0-r1.ebuild,v 1.11 2014/07/22 12:35:35 vapier Exp $

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for the pkg-config implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="
	|| (
		>=dev-util/pkgconfig-0.28-r1[${MULTILIB_USEDEP}]
		>=dev-util/pkgconf-0.9.3-r1[pkg-config,${MULTILIB_USEDEP}]
		>=dev-util/pkgconfig-openbsd-20130507-r1[pkg-config,${MULTILIB_USEDEP}]
	)"
