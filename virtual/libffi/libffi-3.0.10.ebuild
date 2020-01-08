# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# The purpose of this ebuild is to provide quick fallback if and when we need to
# switch back to internal copy of libffi from sys-devel/gcc.

EAPI=5

DESCRIPTION="A virtual for the Foreign Function Interface implementation"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND=">=dev-libs/libffi-3.0.10"
