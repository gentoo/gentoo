# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils xorg-2

DESCRIPTION="X authority file utility"

KEYWORDS=""
IUSE="ipv6"

RDEPEND="x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXext
	x11-libs/libXmu"
DEPEND="${RDEPEND}"

# Tests dependend on dev-util/cmdtest awaiting keywording, bug #511202.
#	test? ( dev-util/cmdtest )

src_configure() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
	)
	xorg-2_src_configure
}

src_test() {
	# Address sandbox failure, bug #527574
	addwrite /proc/self/comm
	autotools-utils_src_test
}
