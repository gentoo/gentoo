# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="ICE authority file utility"

KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libICE"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
