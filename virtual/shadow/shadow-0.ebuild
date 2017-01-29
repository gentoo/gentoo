# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Virtual for user account management utilities"

SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

# >=shadow-4-1 is required because of bug #367633 (user.eclass needs it).
# On Prefix installations we sort of have to hope there is some shadow
# available, on UNIX-like (or emulated) systems this usually is the case.
RDEPEND="!prefix? ( || ( >=sys-apps/shadow-4.1 sys-apps/hardened-shadow ) )"
