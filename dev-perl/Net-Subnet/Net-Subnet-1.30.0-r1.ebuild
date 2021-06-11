# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=JUERD
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Fast IP-in-subnet matcher for IPv4 and IPv6, CIDR or mask"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

RDEPEND="
	>=dev-perl/Socket6-0.250.0
"
DEPEND="${RDEPEND}"
PATCHES=( ${FILESDIR}/${PV}-pod-spelling.patch )
