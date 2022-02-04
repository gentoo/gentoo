# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="animate an icosahedron or other polyhedron"

KEYWORDS="amd64 arm ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~x86-linux"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
