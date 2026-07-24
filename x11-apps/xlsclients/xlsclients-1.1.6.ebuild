# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xorg-meson

DESCRIPTION="X.Org xlsclients application"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND=">=x11-libs/libxcb-1.7"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
