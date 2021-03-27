# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xorg-3

DESCRIPTION="X.Org xlsclients application"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"

RDEPEND="
	>=x11-libs/libxcb-1.7
	>=x11-libs/xcb-util-0.3.8
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
