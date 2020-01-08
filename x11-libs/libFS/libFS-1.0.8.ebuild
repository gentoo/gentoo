# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="X.Org FS library"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="ipv6"

DEPEND="x11-base/xorg-proto
	x11-libs/xtrans"
RDEPEND=""

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ipv6)
	)
}
