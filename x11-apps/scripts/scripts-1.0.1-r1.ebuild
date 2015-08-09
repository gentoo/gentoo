# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

XORG_STATIC="no"
inherit xorg-2

DESCRIPTION="start an X program on a remote machine"
KEYWORDS="amd64 arm ~arm64 ~mips ppc ppc64 s390 sh ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_install() {
	xorg-2_src_install

	# Requires ksh, assumes hostname(1) is in /usr/bin
	rm "${ED}"/usr/bin/xauth_switch_to_sun-des-1
}
