# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JUERD
MODULE_VERSION=1.03
inherit perl-module

DESCRIPTION="Fast IP-in-subnet matcher for IPv4 and IPv6, CIDR or mask"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=dev-perl/Socket6-0.250.0
"
DEPEND="${RDEPEND}"
PATCHES=( ${FILESDIR}/${PV}-pod-spelling.patch )
