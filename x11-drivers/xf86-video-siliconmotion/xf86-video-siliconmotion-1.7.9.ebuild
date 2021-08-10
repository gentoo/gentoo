# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Silicon Motion video driver"

KEYWORDS="amd64 ~mips x86"

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}"
