# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/libffi/libffi-3.0.13-r1.ebuild,v 1.14 2014/07/06 16:56:06 grobian Exp $

# The purpose of this ebuild is to provide quick fallback if and when we need to
# switch back to internal copy of libffi from sys-devel/gcc.

EAPI=5

inherit multilib-build

DESCRIPTION="A virtual for the Foreign Function Interface implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=dev-libs/libffi-3.0.13-r1[${MULTILIB_USEDEP}]"
DEPEND=""
