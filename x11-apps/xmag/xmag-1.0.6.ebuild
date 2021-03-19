# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="X.Org xmag application"

KEYWORDS="amd64 arm ~hppa ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libX11"
DEPEND="${RDEPEND}"
