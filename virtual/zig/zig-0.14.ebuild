# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for Zig toolchain"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

RDEPEND="|| (
		dev-lang/zig-bin:${SLOT}
		dev-lang/zig:${SLOT}
)"
