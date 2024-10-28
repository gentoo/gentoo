# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to depend on any Distribution Kernel"
SLOT="0/${PVR}"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	|| (
		>=sys-kernel/gentoo-kernel-${PV}-r1:${PV}
		>=sys-kernel/gentoo-kernel-bin-${PV}-r1:${PV}
		~sys-kernel/vanilla-kernel-${PV}
	)
"
