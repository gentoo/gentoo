# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org FS library"

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd"
IUSE="ipv6"

RDEPEND="x11-libs/xtrans
	x11-proto/xproto
	x11-proto/fontsproto"
DEPEND="${RDEPEND}"

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
	)
	xorg-2_src_configure
}
