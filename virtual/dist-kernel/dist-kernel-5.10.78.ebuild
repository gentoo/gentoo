# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual to depend on any Distribution Kernel"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm arm64 ppc64 ~x86"

RDEPEND="
	|| (
		~sys-kernel/gentoo-kernel-${PV}
		~sys-kernel/gentoo-kernel-bin-${PV}
		~sys-kernel/vanilla-kernel-${PV}
	)"
