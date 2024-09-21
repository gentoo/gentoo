# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to depend on any Distribution Kernel"
SLOT="asahi/${PVR}"
KEYWORDS="~arm64"

RDEPEND="
	~sys-kernel/asahi-kernel-${PV}:asahi=
"
