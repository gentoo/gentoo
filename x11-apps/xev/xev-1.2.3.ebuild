# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Print contents of X events"

KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~x86-winnt"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
