# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org dmx library"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE=""

RDEPEND="x11-base/xorg-proto
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"
