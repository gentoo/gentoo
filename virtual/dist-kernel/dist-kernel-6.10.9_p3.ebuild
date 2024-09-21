# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to depend on any Distribution Kernel"
SLOT="0/${PVR}"
KEYWORDS="~arm64"

RDEPEND="
	~sys-kernel/asahi-kernel-${PV}
"
