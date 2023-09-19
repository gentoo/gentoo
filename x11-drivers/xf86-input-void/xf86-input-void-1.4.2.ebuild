# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

XORG_TARBALL_SUFFIX="xz"
inherit xorg-3

DESCRIPTION="null input driver"

KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
