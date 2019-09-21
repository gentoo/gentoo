# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="plain text display program for the X Window System"
KEYWORDS="amd64 arm hppa ~mips ppc ppc64 s390 ~sh ~sparc x86"
IUSE=""

RDEPEND="
	x11-libs/libXaw
	x11-libs/libXt
"
DEPEND="${RDEPEND}"
