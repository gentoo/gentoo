# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/iceauth/iceauth-1.0.6.ebuild,v 1.11 2015/03/03 10:30:31 dlan Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="ICE authority file utility"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x86-solaris ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libICE"
DEPEND="${RDEPEND}
	x11-proto/xproto"
