# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="Nvidia 2D only video driver"

KEYWORDS="~alpha amd64 ~ia64 ppc ppc64 x86"

RDEPEND="
	x11-base/xorg-server
	>=x11-libs/libpciaccess-0.10.7"
DEPEND="${RDEPEND}"
